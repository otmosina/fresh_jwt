# frozen_string_literal: true

require 'dry/validation'
require 'jwt'
require 'securerandom' 

require_relative 'fresh_jwt/contract_validator'
require_relative 'fresh_jwt/expiration'
require_relative 'contracts/issuer_contract'
require_relative 'fresh_jwt/payload'
require_relative 'fresh_jwt/store'
require_relative 'fresh_jwt/version'
require_relative 'fresh_jwt/validator'
require_relative 'fresh_jwt/entity/access_token'
require_relative 'fresh_jwt/issuer'
require_relative 'fresh_jwt/store_old'
require_relative 'fresh_jwt/refresher'
require_relative 'fresh_jwt/errors'


# require 'dry/monads'
# TODO payload as dry entity


module FreshJwt


  class Decoder
    extend Dry::Initializer

    option :algorithm, default: -> { 'HS256' }
    option :secret, default: -> { 'SECRET' }

    def decode(token:)
      JWT.decode(token, secret, algorithm)
    end
  end
end
