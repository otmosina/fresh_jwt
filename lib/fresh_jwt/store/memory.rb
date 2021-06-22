module FreshJwt
  module Store
    class Memory
      def initialize
        @store = {}
      end
  
      def save token_object
        @store[token_object.token] = token_object
        return true
      end
  
      def find_by_token token
        if token == 'unknown_token'
        #require 'pry'; binding.pry 
        end
        @store[token]
      end
    end 
  
  end
end