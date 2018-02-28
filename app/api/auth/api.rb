class Auth::Api < Grape::API

  resource :auth do

    desc "authenticates a user"
    params do
      requires :username, type: String, desc: 'your username', documentation: { param_type: 'query' }
      requires :password, type: String, desc: 'your password', documentation: { param_type: 'query' }
    end
    post '/' do
      user = User.authenticate(params[:username], params[:password])
      if user.present?
        access_token = { user_id: user.id.to_str, access_token: AccessTokenAuth.issue(user) }
        status 200
        present access_token, with: Entities::AccessTokenEntity
      else
        error!({ error_msg: 'Bad Authentication Parameters' }, 401)
      end
    end

  end

end
