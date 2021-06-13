module FreshJwt
  class ContractError < StandardError
    DEFAULT_MESSAGE = 'something wrong with Contract'
    def initialize(msg = DEFAULT_MESSAGE, exception_type='custom')
      @exception_type = exception_type
      super(msg) 
    end
    def message
      super
    end
  end
end

class IssuerContract < Dry::Validation::Contract
  params do
    required(:algorithm).filled(:string)
  end
end
