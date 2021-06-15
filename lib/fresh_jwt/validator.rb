module FreshJwt
  class Validator
    extend Dry::Initializer

    option :algorithm, default: -> { 'HS256' }
    option :secret, default: -> { 'SECRET' }

    def call(token)
      payload, alg = JWT.decode(token, secret, algorithm)
      #access_token = Store.find_by_token(token)
      if payload["exp"] > Time.now.to_i
        true
      else
        false
      end
    end
  end
end
