class Balance
  include Mongoid::Document
  include Mongoid::History::Tracker

  #################
  # relationships #
  #################

  embedded_in :credit

  ##########
  # fields #
  ##########

  field :currency, type: String
  field :amount, type: BigDecimal

  ###############
  # validations #
  ###############

  validate :amount_equal_to_credit_limit, on: :create

  ###########
  # methods #
  ###########

  def amount_equal_to_credit_limit
    self.credit.credit_limit == self.amount
  end

end
