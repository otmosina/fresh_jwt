module FreshJwt
  class Validator
    # должен ли валидатор декодить токен
    # или он всего ли проверяет есть ли он в базе и какой у него по базе срок жизни
    # а вот аутентификатор уже должен пробовать раскодировать токен, проверить срок жизни по пейлооаду и взять данные из полезной нагрузки
    extend Dry::Initializer


    option :algorithm, default: -> { 'HS256' }
    option :secret, default: -> { 'SECRET' }
    option :token_repo, default: -> { Store }

    def call(token)
      access_token = token_repo.find_by_token(token)
      if payload["exp"] > Time.now.to_i
        true
      else
        false
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
