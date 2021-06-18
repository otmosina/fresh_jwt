module FreshJwt
  class Validator
    # должен ли валидатор декодить токен
    # или он всего ли проверяет есть ли он в базе и какой у него по базе срок жизни
    # а вот аутентификатор уже должен пробовать раскодировать токен, проверить срок жизни по пейлооаду и взять данные из полезной нагрузки
    extend Dry::Initializer
    include Dry::Monads[:result, :do]

    option :algorithm, default: -> { 'HS256' }
    option :secret, default: -> { 'SECRET' }
    option :token_repo, default: -> { Store }

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
        Failure(decode_error: e.message)
      end
    end

    def valid_payload? payload
      if payload["exp"] > Time.now.to_i
        Success()
      else
        Failure(valid_payload: true)
      end      
    end


    def auth(token)
      payload, alg = JWT.decode(token, secret, algorithm)
      #access_token = Store.find_by_token(token)
      if payload["exp"] > Time.now.to_i
        true
      else
        false
      end
    end    
  end
end
