module FreshJwt  
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