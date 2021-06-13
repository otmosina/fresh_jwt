# frozen_string_literal: true

require 'dry/validation'
require 'jwt'
require 'securerandom' 

require_relative 'validator'
require_relative 'fresh_jwt/expiration'
require_relative 'contracts/issuer_contract'


require 'dry/monads'
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
    option :exp, proc(&:to_i), default: -> { iat + 10*60 } #default: ->(val) { iat + 10*60}
    option :user_id, proc(&:to_i), optional: true
  end
    
  class Issuer
    extend Dry::Initializer

    option :payload, default: proc { Payload.new } #why we need new i do not understand, coz class is callable
    option :algorithm, default: -> { 'HS256' } #RS256
    option :secret, default: -> { SecureRandom.hex }

    option :user_id, proc(&:to_i), default: proc{ rand(1000) }

    def call

      # TODO: monadic handle contract
      
      result = IssuerContract.new.call(algorithm: algorithm)
      if result.success?
        puts "all good"
      else
        p result.errors.to_h
        raise ContractError  
      end
      
      payload_json = Payload.dry_initializer.attributes(payload).merge(user_id: user_id)
      {
        jti: payload.jti,
        iat: payload.iat,
        exp: payload.exp, 
        user_id: payload.user_id        
      }
      token = JWT.encode(payload_json, secret, algorithm)
      return [result, token]
    end
  end
end
issuer = FreshJwt::Issuer.new(algorithm: 'HS256') 
token = begin
  issuer.call
rescue FreshJwt::ContractError => e
  p e.message
  nil
end
exit(0) unless token
p token 
p JWT.decode(token[1], issuer.secret, 'HS256')

payload = FreshJwt::Payload.new({})



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