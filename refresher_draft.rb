require 'dry/monads'
require 'dry/monads/do'
require 'securerandom'

#extend Dry::Monads[:maybe, :result]
#p None().to_result( {error: :some} )

class Refresher
  include Dry::Monads[:result, :do]

  def initialize(token:)
    @token = token
  end
  
  def call
    token = yield validate_token @token
    new_token = yield create_new_token token#.value!
    store_token new_token#.value!
  end

  def validate_token token
    if true
      Success(token)
    else
      Failure(:token_not_valid)
    end
  end

  def create_new_token token
    if true
      Success(SecureRandom.hex<< ' ' << token)
    else
      Failure(:cannot_create_token)
    end
  end

  def store_token token
    if true
      $db << token
      Success(token)
    else
      Failure(:some_errors_when_store)
    end
  end

end

$db = []
token = Refresher.new(token: '1').call
#p token.failure?
p token.value_or{ |err| err }
