module FreshJwt  

  module Store

    module Mixin
      include Dry::Monads[:result]
      def single_transaction token
        begin
          self.save token
          return Success()
        rescue Exception => error
          #puts error
          return Failure(error: error.message)
        end      
      end
    end

    require 'delegate'
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
  class Memory
    #include StoreMixin

    def initialize
      @store = {}
    end

    def save token_object
      #unless token_object.respond_to?('token')
      #  raise TokenObjectError
      #end 
      @store[token_object.token] = token_object
      return true
    end

    def find_by_token token
      @store[token]
    end
  end 
  class StoreOld
    extend Dry::Monads[:result]
    @@store = []
    #{
    #  "token_value": {
    #    jti: 1,
    #    exp: 2,
    #    type: :access
    #  }
    #}

    def self.save token
      
      @@store << token
    end
    def self.get token
      @@store.find{ |t| t == token }
    end
    def self.all
      @@store
    end

    def self.find_by_token token
      @@store.find{ |t| t.token == token }
    end

    def self.single_transaction token
      begin
        save token
        return Success()
      rescue Exception => error
        #puts error
        return Failure(error: error.message)
      end      
    end

    def self.transaction &block
      begin
        block.call
        return Success()
      rescue Exception => error

        puts error
        return Failure(error: error.message)
      end
    end
    
  end
end
