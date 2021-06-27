
require 'delegate'
module FreshJwt
  module Store
    class Decorator < SimpleDelegator
    
      include Dry::Monads[:result]
      class TokenObjectError < StandardError
        DEFAULT_MESSAGE = 'Token object has wrong structure for Tokens store'
        def initialize(msg = DEFAULT_MESSAGE, exception_type='token')
          @exception_type = exception_type
          super(msg)
        end
      end
    
      def single_transaction token, type=:access
        token_object = if type.to_sym == :access
          Entity::AccessToken.new(token: token)
        else
          Entity::RefreshToken.new(token: token)
        end

        begin
          self.save token_object
          return Success()
        rescue Exception => error
          #puts error
          return Failure(error: error.message)
        end      
      end

      # TODO this method is deprecated
      def save token_object
        #raise StandardError
        unless token_object.respond_to?('token')
          raise TokenObjectError
        end 
        super(token_object)
      end

      def find_by_token token
        
        # TODO wrap incoming method to monads
        #return super(token)
        #
        token_object = super(token)
        if token_object
          Success(token_object)
        else
          Failure(error: :token_not_found)
        end
      end
    end
  end
end