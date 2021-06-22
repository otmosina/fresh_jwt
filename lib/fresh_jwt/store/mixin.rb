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

        def find_by_token token
          # TODO wrap incoming method to monads
          #return super(token)
          if super(token)
            Success(token)
          else
            Failure(error: :token_not_found)
          end
        end        
    end
  end
end