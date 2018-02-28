class Credit
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Tracker

  #################
  # relationships #
  #################

  belongs_to :user

  embeds_one :balance, cascade_callbacks: true, autobuild: true
  has_many :transactions,
            as: :transactionable,
            class_name: 'Transaction',
            autosave: true
            # after_add: :update_balance

  accepts_nested_attributes_for :transactions
  accepts_nested_attributes_for :balance

  ##########
  # fields #
  ##########

  field :active, type: Boolean
  field :credit_limit, type: BigDecimal
  field :apr, type: Float
  field :next_billing_statement, type: DateTime
  field :last_billing_statement, type: DateTime

  ###############
  # validations #
  ###############

  validates_presence_of :active, :credit_limit, :apr, :next_billing_statement
  validates :apr, numericality: { less_than_or_equal_to: 100, greater_than_or_equal_to: 0 }
  validates :credit_limit, numericality: { greater_than_or_equal_to: 0 }

  validates_presence_of :balance
  validates_associated :transactions

  ###########
  # methods #
  ###########

  def id_str
    self.id.to_str
  end

  def next_billing_statement
    (Date.today + 30.days).to_time.to_i
  end

  # triggered on transaction added
  def update_balance(transaction)
    if transaction.succeeded?
      sign = transaction.payment? ? 1 : -1
      self.balance.update_attributes!(amount: (self.balance.amount + (transaction.amount * sign)))
    end
  end

  # triggered on transaction deleted
  def rollback_balance(transaction)
    if transaction.succeeded?
      sign = transaction.payment? ? -1 : 1
      self.balance.update_attributes!(amount: (self.balance.amount + (BigDecimal.new(transaction.amount_was) * sign)))
    end
  end

  def initialize(attr = {})
    super
    self.next_billing_statement = next_billing_statement
    self.balance.update_attributes!({currency: 'usd', amount: self.credit_limit})
  end

end
