# frozen_string_literal: true

require 'dry/validation'
require 'jwt'
require 'securerandom' 

require_relative 'contract_validator'
require_relative 'fresh_jwt/expiration'
require_relative 'contracts/issuer_contract'
require_relative 'fresh_jwt/payload'
require_relative 'fresh_jwt/store'
require_relative 'fresh_jwt/version'
require_relative 'fresh_jwt/entity/access_token'


require 'dry/monads'
#TODO payload as dry entity


module FreshJwt  


  class Decoder
    extend Dry::Initializer

    option :algorithm, default: -> { 'HS256' }
    option :secret, default: -> { 'SECRET' }

    def decode(token:)
      JWT.decode(token, secret, algorithm)
    end
  end

  class Validator < Decoder
    def validate(token)
      payload, alg = self.decode(token: token)
      #access_token = Store.find_by_token(token)
      if payload["exp"] > Time.now.to_i + 10000
        true
      else
        false
      end
    end
  end
  class Issuer
    extend Dry::Initializer
    REFRESH_EXPIRATION = 60*60*24


    option :payload, default: proc { Payload.new } #why we need new i do not understand, coz class is callable
    # TODO: describe enum type for 2 algo
    option :algorithm, default: -> { 'HS256' } #RS256 
    option :secret, default: -> { 'SECRET' }
    option :refresh_token, proc(&:to_s), default: -> { SecureRandom.hex }
    option :tokens_repo, default: -> { Store }

    def call
      validate_params params
      token = JWT.encode(payload.to_hash, secret, algorithm)
      tokens_repo.save Entity::AccessToken.new(
        token: token, 
        payload: payload,
        issued_at: payload.exp
      )
      tokens_repo.save Entity::RefreshToken.new(
        token: refresh_token, 
        issued_at: Time.now.to_i
      )
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
