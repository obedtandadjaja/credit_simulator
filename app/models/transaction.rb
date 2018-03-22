class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Tracker

  #################
  # relationships #
  #################

  belongs_to :transactionable, polymorphic: true, class_name: 'Credit'

  ##########
  # fields #
  ##########

  field :status, type: String, default: 'succeeded'
  field :_type, as: :type

  ###############
  # validations #
  ###############

  validates_inclusion_of :status, in: [ 'succeeded', 'failed' ]

  ###########
  # methods #
  ###########

  def id_str
    self.id.to_str
  end

  def self.charge
    where(_type: 'Charge')
  end

  def self.payment
    where(_type: 'Payment')
  end

  def charge?
    self.type == 'Charge'
  end

  def payment?
    self.type == 'Payment'
  end

  def self.succeeded
    where(status: 'succeeded')
  end

  def succeeded?
    self.status == 'succeeded'
  end

  def failed?
    self.status == 'failed'
  end

end
