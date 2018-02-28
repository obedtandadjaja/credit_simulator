class V1::Transaction::Api < Grape::API

  before do
    authenticate!
  end

  helpers V1::SharedParams

  resource :transaction do

    #########
    # Get / #
    #########

    desc "Returns all transactions. Admin only", {
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
          order_by:%i(type amount currency status created_at updated_at),
          default_order_by: :created_at,
          default_order: :desc
    end
    paginate
    get '/' do
      authorize ['admin']
      present paginate(::Transaction
        .send(params[:order], params[:order_by])
        .from(params[:start_date].to_i)
        .to(params[:end_date].nil? ? DateTime.now.to_i : params[:end_date].to_i)), with: Entities::TransactionEntity
    end

    ############
    # Get /:id #
    ############

    desc "Returns a transaction for a given transaction id", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Transaction id.'
    end
    get '/:id' do
      transaction = ::Transaction.find(params[:id])
      if @current_user.credits.include?(transaction.transactionable) || is_admin?
        present transaction, with: Entities::TransactionEntity
      else
        return_unauthorized_access('You have no permission to access other user\'s account')
      end
    end

    ###############
    # Delete /:id #
    ###############

    desc "Deletes transaction. Admin only", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Transaction id.'
    end
    delete '/:id' do
      authorize ['admin']
      transaction = ::Transaction.find(params[:id])
      if is_admin?

        # check if payment deleted will make balance go negative
        if transaction.payment?
          if transaction.transactionable.balance.amount < transaction.amount
            return_bad_request('Insufficient funds.')
          end
        end

        if transaction.delete
          status = { message: 'Successfully deleted transaction', status: 'SUCCESS', processed_at: DateTime.now.to_s }
          transaction.transactionable.rollback_balance(transaction)
        else
          status = { message: 'Failed deleting transaction', status: 'FAILED', processed_at: DateTime.now.to_s }
        end
        present status, with: Entities::StatusEntity
      else
        return_unauthorized_access('Not enough permission.')
      end
    end

    ############
    # Put /:id #
    ############

    desc "Updates transaction. Admin only", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'Credit id.', documentation: { value: 'greater than or equal to 0' }
      optional :amount, type: Integer
      optional :currency, type: String
      optional :status, type: String
    end
    put '/:id' do
      authorize ['admin']
      should_be_positive params[:amount] if params[:amount].present?

      transaction = ::Transaction.find(params[:id])
      if is_admin?

        # check payment
        if transaction.payment?
          # check if payment failed will make balance go negative
          if params[:status].present? && params[:status] == 'failed'
            return return_bad_request('Insufficient funds.') if transaction.transactionable.balance.amount < transaction.amount
          end

          # check if payment lowered will make balance go negative
          if params[:amount].present?
            change = params[:amount] - transaction.amount
            if transaction.transactionable.balance.amount + change < 0
              return return_bad_request('Insufficient funds.')
            end
          end
        # check charge
        else
          # check if charge succeeded will make balance go negative
          if params[:status].present? && params[:status] == 'succeeded'
            return return_bad_request('Insufficient funds.') if transaction.transactionable.balance.amount < transaction.amount
          end

          #check if charge increased will make balance go negative
          if params[:amount].present?
            change = params[:amount] - transaction.amount
            if transaction.transactionable.balance.amount - change < 0
              return return_bad_request('Insufficient funds.')
            end
          end
        end

        status = {}
        if transaction.update_attributes!(params)
          # update credit balance
          transaction.transactionable.rollback_balance(transaction)
          status = { message: 'Successfully updated transaction', status: 'SUCCESS', processed_at: DateTime.now.to_s }
          if transaction.succeeded?
            transaction.transactionable.update_balance(transaction)
          end
        else
          status = { message: 'Failed updating transaction', status: 'FAILED', processed_at: DateTime.now.to_s }
        end
        present status, with: Entities::StatusEntity
      else
        return_unauthorized_access('Not enough permission.')
      end
    end
  end

end
