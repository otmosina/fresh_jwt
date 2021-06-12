# frozen_string_literal: true

require 'dry/validation'
require 'jwt'
require 'securerandom' 

#TODO payload as dry entity
module Entity
  module Callable
    def call(*args)
      new(*args)
    end

    alias [] call
  end
end


module FreshJwt

  class Payload
    extend Dry::Initializer
    extend Entity::Callable

    option :jti, default: proc { SecureRandom.hex }
    option :iat, proc(&:to_i), default: proc { Time.now }
    option :exp, proc(&:to_i), default: -> { iat + 10*60} #default: ->(val) { iat + 10*60}
    option :user_id, proc(&:to_i), optional: true
  end
    



  class IssuerContract < Dry::Validation::Contract
    params do
      required(:algorithm).filled(:string)
    end
  end
  class Issuer
    extend Dry::Initializer

    option :payload, default: -> { Hash.new }
    option :algorithm, default: -> { 'HS256' } #RS256

    def call
      contract = IssuerContract.new
      # TODO: monadic handle contract
      result = contract.call(algorithm: algorithm)
      # TODO: monadic handle contract
      
      secret = 'secret'

      #(JWT ID) 
      jti = SecureRandom.hex
      iat = Time.now.to_i
      exp = iat + 10 * 60 
      user_id = rand(666)
      payload = {
        jti: jti,
        iat: iat,
        exp: exp, 
        user_id: user_id        
      }
      token = JWT.encode(payload, secret, algorithm)
      return [result, token]
    end
  end
end

token = FreshJwt::Issuer.new(algorithm: "HS256").call
p token 
p JWT.decode(token[1], 'secret', 'HS256')

payload = FreshJwt::Payload.new({})

require 'pry'
binding.pry

=begin

module Jwt
  module Issuer
    module_function

    def call(user)
      access_token, jti, exp = Jwt::Encoder.call(user)
      refresh_token = user.refresh_tokens.create!
      Jwt::Whitelister.whitelist!(
        jti: jti,
        exp: exp,
        user: user
      )

      [access_token, refresh_token]
    end
  end
end


module Jwt
  module Encoder
    module_function

    def call(user)
      jti = SecureRandom.hex
      exp = Jwt::Encoder.token_expiry
      access_token = JWT.encode(
        {
          user_id: user.id,
          jti: jti,
          iat: Jwt::Encoder.token_issued_at.to_i,
          exp: exp
        },
        Jwt::Secret.secret
      )

      [access_token, jti, exp]
    end

    def token_expiry
      (Jwt::Encoder.token_issued_at + Jwt::Expiry.expiry).to_i
    end

    def token_issued_at
      Time.now
    end
  end
end
=end