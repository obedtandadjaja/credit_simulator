class Payment < Transaction
  include Mongoid::Document
  include Mongoid::History::Tracker

  ##########
  # fields #
  ##########

  field :amount, type: BigDecimal
  field :currency, type: String

  ###############
  # validations #
  ###############

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, inclusion: { in: %w(usd) }

  ###########
  # methods #
  ###########

  def self.charge?
    false
  end

  def self.payment?
    true
  end

end
