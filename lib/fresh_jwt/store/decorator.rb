
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
    
      def single_transaction token
        begin
          self.save token
          return Success()
        rescue Exception => error
          #puts error
          return Failure(error: error.message)
        end      
      end 
      def save token_object
        unless token_object.respond_to?('token')
          raise TokenObjectError
        end 
        super(token_object)
      end
    end
  end
end