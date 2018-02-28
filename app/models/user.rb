class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::History::Tracker
  include ActiveModel::SecurePassword

  #############
  # relations #
  #############

  has_many :credits, autosave: true

  ##########
  # fields #
  ##########

  field :email, type: String
  field :username, type: String
  field :password_digest, type: String
  field :role, type: String
  field :first_name, type: String
  field :last_name, type: String

  has_secure_password

  ###############
  # validations #
  ###############

  validates_presence_of :first_name, :last_name, :email, :username, :password_digest, :role
  validates_uniqueness_of :username
  validates_inclusion_of :role, in: [ 'user', 'admin' ]

  validates_associated :credits

  ###########
  # methods #
  ###########

  def id_str
    self.id.to_str
  end

  def formatted_name
    [first_name, last_name].join(" ")
  end

  def self.authenticate(username, password)
    user = User.where(username: username).first
    if user && user.authenticate(password)
      user
    end
  end
end
