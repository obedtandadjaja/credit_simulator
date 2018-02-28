class Entities::AccessTokenEntity < Grape::Entity

  expose :user_id
  expose :access_token

end
