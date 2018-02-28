class V1::BaseApi < Grape::API

  prefix 'api/v1'
  formatter :json, CustomFormatter

  helpers do
    # check if authenticated
    def authenticate!
      return_unauthorized_access unless current_user
    end

    # check scope from token
    def authorize(scope)
      return_unauthorized_access('Not enough permission.') unless scope.include? @current_user.role
    end

    # displays unauthorized error
    def return_unauthorized_access(msg = '')
      error!({ status: 401, error_msg: 'Unauthorized. ' + msg }, 401)
    end

    # displays bad request error
    def return_bad_request(msg = '')
      error!({ status: 400, error_msg: 'Bad Request. ' + msg }, 400)
    end

    # get current_user from token
    def current_user
      token = headers['Authorization']
      if token
        token = token.gsub(/Basic /, '')
        @current_user = AccessTokenAuth.verify(token)
        return !@current_user.nil?
      end
    end

    # check positivity of a number
    def should_be_positive(num)
      return_bad_request('Must be positive number.') if num < 0
    end

    # true if user has admin role
    def is_admin?
      @current_user.role == 'admin'
    end
  end

  mount V1::User::Api
  mount V1::Credit::Api
  mount V1::Transaction::Api
end
