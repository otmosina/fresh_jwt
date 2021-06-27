# frozen_string_literal: true

#TODO: outside of module
class IssuerContract < Dry::Validation::Contract
  params do
    required(:algorithm).filled(:string)
  end
end
