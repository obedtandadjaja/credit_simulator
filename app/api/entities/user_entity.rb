class Entities::UserEntity < Grape::Entity

  expose :id_str, as: :id
  expose :username, :email, :role, :created_at, :updated_at
  expose :formatted_name, as: :full_name
  expose :credits do |instance, options|
    Entities::CreditEntity.represent instance.credits, only: [:id]
  end

end
