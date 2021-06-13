module FreshJwt
  class ContractError < StandardError
    def message
      "something wrong with Contract"
    end
  end
end

class IssuerContract < Dry::Validation::Contract
  params do
    required(:algorithm).filled(:string)
  end
end

