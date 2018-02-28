class V1::User::Api < Grape::API

  before do
    authenticate!
  end

  helpers V1::SharedParams

  resource :user do

    ############
    # Get /:id #
    ############

    desc "Returns a user for a given user id", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'User id.'
    end
    get '/:id' do
      user = ::User.find(params[:id])
      if @current_user == user || is_admin?
        present user, with: Entities::UserEntity
      else
        return_unauthorized_access('You have no permission to access other users\' account')
      end
    end

    ####################
    # Get /:id/credits #
    ####################

    desc "Returns a user for a given user id", {
      headers: {
        "Authorization" => {
          description: "Authentication token. Format: 'Basic AUTH_TOKEN'",
          required: true
        }
      }
    }
    params do
      requires :id, type: String, desc: 'User id.'
      use :period
      use :order,
          order_by:%i(credit_limit apr next_billing_statement last_billing_statement created_at updated_at),
          default_order_by: :created_at,
          default_order: :desc
    end
    paginate
    get '/:id/credits' do
      user = ::User.find(params[:id])
      if @current_user == user || is_admin?
        present paginate(user.credits
          .send(params[:order], params[:order_by])
          .from(params[:start_date].to_i)
          .to(params[:end_date].nil? ? DateTime.now.to_i : params[:end_date].to_i)), with: Entities::CreditEntity
      else
        return_unauthorized_access('You have no permission to access other users\' account')
      end
    end

    #########
    # Get / #
    #########

    desc "Returns all users. Admin only", {
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
          order_by:%i(id first_name last_name username email created_at updated_at),
          default_order_by: :created_at,
          default_order: :desc
    end
    paginate
    get '/' do
      authorize ['admin']
      present paginate(::User.all
        .send(params[:order], params[:order_by])
        .from(params[:start_date].to_i)
        .to(params[:end_date].nil? ? DateTime.now.to_i : params[:end_date].to_i)), with: Entities::UserEntity
    end

  end

end
