class Entities::StatusEntity < Grape::Entity

  expose :error_msg, :status, :processed_at

end
