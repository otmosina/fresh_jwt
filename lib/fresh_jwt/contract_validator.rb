require 'dry/monads'
#это штука типа оборачивает монады...
require 'dry/monads/do'
module FreshJwt
  class ContractValidator
    include Dry::Monads[:result]
    include Dry::Monads::Do.for(:call)
  
    def call(contract, params)
      result = contract.new.call(params)
      if result.success?
        Success(result)
      else
        Failure(result.errors.to_h)
      end  
    
    end
  end
end


  #def validate
  #  return Success(data) || Failure(:not_valid)
  #end