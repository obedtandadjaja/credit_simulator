class Charge < Transaction
  include Mongoid::Document
  include Mongoid::History::Tracker

  ##########
  # fields #
  ##########

  field :amount, type: BigDecimal
  field :currency, type: String
  field :description, type: String

  ###############
  # validations #
  ###############

  validates_presence_of :amount, :currency, :description

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, inclusion: { in: %w(usd) }

end
