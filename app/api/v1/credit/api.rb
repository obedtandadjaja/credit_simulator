class V1::Credit::Api < Grape::API

  before do
    authenticate!
  end

  helpers V1::SharedParams

  resource :credit do

    #########
    # Get / #
    #########

    desc "Returns all credits. Admin only", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      use :period
      use :order,
          order_by:%i(credit_limit apr next_billing_statement last_billing_statement created_at updated_at),
          default_order_by: :created_at,
          default_order: :desc
    end
    paginate
    get '/' do
      authorize ['admin']
      present paginate(::Credit
        .send(params[:order], params[:order_by])
        .from(params[:start_date].to_i)
        .to(params[:end_date].nil? ? DateTime.now.to_i : params[:end_date].to_i)), with: Entities::CreditEntity
    end

    ############
    # Get /:id #
    ############

    desc "Returns a credit for a given credit id", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Credit id.'
    end
    get '/:id' do
      credit = ::Credit.find(params[:id])
      if @current_user.credits.include?(credit) || is_admin?
        present credit, with: Entities::CreditEntity
      else
        return_unauthorized_access('You have no permission to access other users\' account')
      end
    end

    #########################
    # Get /:id/transactions #
    #########################

    desc "Returns transactions for a given credit id", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Credit id.'
      use :period
      use :order,
          order_by:%i(amount type status currency created_at updated_at),
          default_order_by: :created_at,
          default_order: :desc
    end
    paginate
    get '/:id/transactions' do
      credit = ::Credit.find(params[:id])
      if @current_user.credits.include?(credit) || is_admin?
        present paginate(credit.transactions
          .send(params[:order], params[:order_by])
          .from(params[:start_date].to_i)
          .to(params[:end_date].nil? ? DateTime.now.to_i : params[:end_date].to_i)), with: Entities::TransactionEntity
      else
        return_unauthorized_access('You have no permission to access other user\'s account')
      end
    end

    ##########
    # Post / #
    ##########

    desc "Creates new credit for current user", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :credit_limit, type: BigDecimal, desc: 'Credit limit'
      requires :apr, type: Float, desc: 'APR percentage'
    end
    post '/' do
      credit = ::Credit.new(credit_limit: params[:credit_limit], apr: params[:apr], active: true)
      @current_user.credits << credit
      present credit, with: Entities::CreditEntity
    end

    ###############
    # Delete /:id #
    ###############

    desc "Deletes credit. Admin only", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Credit id.'
    end
    delete '/:id' do
      authorize ['admin']
      credit = ::Credit.find(params[:id])
      if @current_user.credits.include?(credit) || is_admin?
        status = credit.delete ?
          { message: 'Successfully deleted credit', status: 'SUCCESS', processed_at: DateTime.now.to_s } :
          { message: 'Failed deleting credit', status: 'FAILED', processed_at: DateTime.now.to_s }
        present status, with: Entities::StatusEntity
      else
        return_unauthorized_access('You have no permission to access other user\'s account')
      end
    end

    ############
    # Put /:id #
    ############

    desc "Updates credit. Admin only", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Credit id.'
      optional :credit_limit, type: Integer
      optional :apr, type: Float
      optional :active, type: Boolean
    end
    put '/:id' do
      authorize ['admin']
      should_be_positive params[:credit_limit] if params[:credit_limit].present?

      credit = ::Credit.find(params[:id])
      if is_admin?

        # check if lowered credit will make balance go negative
        if params[:crediti_limit].present?
          change = params[:credit_limit] - credit.credit_limit
          if credit.balance.amount + change < 0
            return return_bad_request('Insufficient funds.')
          end
        end

        status = credit.update_attributes(params) ?
          { message: 'Successfully updated credit', status: 'SUCCESS', processed_at: DateTime.now.to_s } :
          { message: 'Failed updating credit', status: 'FAILED', processed_at: DateTime.now.to_s }
        present status, with: Entities::StatusEntity
      else
        return_unauthorized_access('You have no permission to access other user\'s account')
      end
    end

    ####################
    # Post /:id/charge #
    ####################

    desc "Creates new charge for credit product", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Credit id.'
      requires :currency, type: String
      requires :amount, type: Integer, desc: 'Amount in cents'
      requires :description, type: String, desc: 'Description of the charge (i.e. vendor name)'
    end
    post '/:id/charge' do
      should_be_positive params[:amount] if params[:amount].present?

      credit = ::Credit.find(params[:id])
      if @current_user.credits.include?(credit) || is_admin?
        if credit.balance.amount >= BigDecimal.new(params[:amount])
          charge = ::Charge.new(params.merge({_id: BSON::ObjectId.new}))
          status = charge &&
                   credit.transactions << charge &&
                   credit.update_balance(charge) ?
                    { message: 'Charge has successfully submitted', status: 'SUCCESS', processed_at: DateTime.now.to_s } :
                    { message: 'Failed to submit charge', status: 'FAILED', processed_at: DateTime.now.to_s }
          present status, with: Entities::StatusEntity
        else
          return_bad_request('Insufficient funds.')
        end
      else
        return_unauthorized_access('You have no permission to access other user\'s account')
      end
    end

    #####################
    # Post /:id/payment #
    #####################

    desc "Creates new payment for credit product", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Credit id.'
      requires :currency, type: String
      requires :amount, type: Integer, desc: 'Amount in cents'
    end
    post '/:id/payment' do
      should_be_positive params[:amount] if params[:amount].present?

      credit = ::Credit.find(params[:id])
      if @current_user.credits.include?(credit) || is_admin?
        payment = ::Payment.new(params.merge({_id: BSON::ObjectId.new}))
        status = payment &&
                 credit.transactions << payment &&
                 credit.update_balance(payment) ?
                  { message: 'Payment has successfully submitted', status: 'SUCCESS', processed_at: DateTime.now.to_s } :
                  { message: 'Failed to submit payment', status: 'FAILED', processed_at: DateTime.now.to_s }
        present status, with: Entities::StatusEntity
      else
        return_unauthorized_access('You have no permission to access other user\'s account')
      end
    end

  end

end
