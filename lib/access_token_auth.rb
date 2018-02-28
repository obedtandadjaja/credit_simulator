require 'jwt'

class AccessTokenAuth

  ALGORITHM = 'HS256'

  def self.issue(user)
    JWT.encode(
      generate_payload(user),
      auth_secret,
      ALGORITHM,
      { typ: 'JWT' }
    )
  end

  def self.verify(token)
    payload = decode(token)

    return nil if payload.nil?
    return nil if payload['exp'] < DateTime.now.to_i

    return User.where(username: payload['username']).first
  end

  def self.decode(token)
    begin
      JWT.decode(
        token,
        auth_secret,
        true,
        { algorithm: ALGORITHM }
      ).first
    rescue JWT::VerificationError
      nil
    rescue JWT::DecodeError
      nil
    end
  end

  def self.auth_secret
    ENV['JWT_SECRET']
  end

  def self.generate_payload(user)
    payload = AccessTokenPayload.new(user.username)
    payload.as_json
  end

end
