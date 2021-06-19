module FreshJwt  
  module StoreMixin
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
  class Memory
    include StoreMixin
    class TokenObjectError < StandardError
      DEFAULT_MESSAGE = 'Token object has wrong structure for Tokens store'
      def initialize(msg = DEFAULT_MESSAGE, exception_type='token')
        @exception_type = exception_type
        super(msg)
      end
    end
    def initialize
      @store = {}
    end

    def save token_object
      unless token_object.respond_to?('token')
        raise TokenObjectError
      end 
      @store[token_object.token] = token_object
      return true
    end

    def find_by_token token
      @store[token]
    end
  end 
  class Store
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

# Example of transaction implementation
# TODO: check implementation on ActiveRecord

#def start(shopper, shipment)
#  repo.transaction do
#    assembly = yield start_assembly(shopper, shipment)
#    confirm_assignments(shopper, shipment)
#    Success(assembly)
#  end
#end