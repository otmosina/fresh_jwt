module FreshJwt  
  class Store
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
  end
end