class Entities::CreditEntity < Grape::Entity

  expose :id_str, as: :id
  expose :credit_limit, :apr, :active, :next_billing_statement, :last_billing_statement, :created_at, :updated_at
  expose :balance, using: Entities::BalanceEntity
  expose :transactions, using: Entities::TransactionEntity

end
