# frozen_string_literal: true

module FreshJwt
  class Refresher
    class TokenExpiredError < StandardError; end
    extend Dry::Initializer
    include Dry::Monads[:result, :do]
    option :repo, default: -> { Store.repo }

    def call(refresh_token)
      token_object = yield repo.find_by_token refresh_token
      
      yield expiration_validate token_object

      
      Success(token_object)
      #if token_object
      #  Success(token_object)
      #else
      #  Failure(error: :token_not_found)
      #end
      #yield validate token

    end

    def expiration_validate token_object
      if token_object.expired?
        Failure(error: TokenExpiredError.new)
      else
        Success()
      end  
    end

    def validate token
      Success()
    end
  end
end

#FreshJwt::Store::Manager.repo

#FreshJwt::Store::Manager