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
      validate_params params
      payload_json = payload.params_to_hash.merge(user_id: user_id)
      token = JWT.encode(payload_json, secret, algorithm)
      return token
    end

    def params
      @params ||= self.class.dry_initializer.attributes(self)
    end

    def validate_params params
      result = IssuerContract.new.call(params)
      unless result.success?
        raise ContractError.new(result.errors.to_h)  
      end
    end

    
  end
end
