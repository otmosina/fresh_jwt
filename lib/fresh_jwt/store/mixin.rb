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
  end
end