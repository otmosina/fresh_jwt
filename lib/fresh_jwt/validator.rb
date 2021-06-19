module FreshJwt
  class Validator
    extend Dry::Initializer
    include Dry::Monads[:result, :do]

    option :algorithm, default: -> { 'HS256' }
    option :secret, default: -> { 'SECRET' }
    option :token_repo, default: -> { StoreOld }

    def call(token)
      yield valid_by_store? token
      payload, _ = yield decode token
      valid_payload? payload  
    end

    def valid_by_store? token
      #access_token = token_repo.find_by_token(token)
      #if access_token.expired_at > Time.now.to_i      
      if true 
        return Success()
      else
        return Failure(validator: :invalid_by_store)
      end
    end

    def decode token
      begin 
        result = JWT.decode(token, secret, true, {algorithm: algorithm})
        Success(result)
      rescue JWT::VerificationError, JWT::DecodeError => e
        Failure(decode_error: ["Cannot validate", e.message])
      end
    end

    def valid_payload? payload
      if payload["exp"] > Time.now.to_i
        Success()
      else
        Failure(valid_payload: false)
      end      
    end
  end
end
