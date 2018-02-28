class AccessTokenPayload

  attr_accessor :iat, :exp, :username

  def initialize(username)
    self.username = username
    set_issued_time
    set_expiration
  end

  def expired?
    DateTime.now >= self.expires_at
  end

  private

  def set_issued_time
    self.iat = DateTime.now.to_i
  end

  def set_expiration
    self.exp = (DateTime.now+30.minutes).to_i
  end

end
