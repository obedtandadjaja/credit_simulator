class Entities::TransactionEntity < Grape::Entity

  expose :id_str, as: :id
  expose :_type, as: :type
  expose :currency, :amount
  expose :description, safe: true
  expose :created_at, :updated_at

end
