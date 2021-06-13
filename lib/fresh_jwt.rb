# frozen_string_literal: true

require 'dry/validation'
require 'jwt'
require 'securerandom' 

require_relative 'validator'
require_relative 'fresh_jwt/expiration'
require_relative 'contracts/issuer_contract'
require_relative 'fresh_jwt/payload'


require 'dry/monads'
#TODO payload as dry entity


module FreshJwt    
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
