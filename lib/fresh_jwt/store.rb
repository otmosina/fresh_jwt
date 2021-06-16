module FreshJwt  
  class Store
    extend Dry::Monads[:result]
    @@store = []
    def self.save token
      @@store << token
    end
    def self.get token
      @@store.find{ |t| tt == token }
    end
    def self.all
      @@store
    end

    def self.transaction &block
      begin
        block.call
      rescue Exception => error

        puts error
        return Failure(error: error.message)
      end
    end
  end
end