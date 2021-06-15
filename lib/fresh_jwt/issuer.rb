module FreshJwt

  class Issuer
    extend Dry::Initializer
    REFRESH_EXPIRATION = 60*60*24


    option :payload, default: proc { Payload.new } #why we need new i do not understand, coz class is callable
    # TODO: describe enum type for 2 algo
    option :algorithm, default: -> { 'HS256' } #RS256 
    option :secret, default: -> { 'SECRET' }
    option :refresh_token, proc(&:to_s), default: -> { SecureRandom.hex }
    option :tokens_repo, default: -> { Store }



    def call
      validate_params params
      token = JWT.encode(payload.to_hash, secret, algorithm)
      access_token = Entity::AccessToken.new(token: token)
      refresh_token = Entity::RefreshToken.new(token: token)
      tokens_repo.transaction do
        tokens_repo.save access_token
        tokens_repo.save refresh_token
      end

      #tokens_repo.save Entity::AccessToken.new(
      #  token: token
      #)
      #tokens_repo.save Entity::RefreshToken.new(
      #  token: refresh_token
      #)
      return access_token, refresh_token
    end

    def params
      @params ||= self.class.dry_initializer.attributes(self)
    end

    def validate_params params
      result = IssuerContract.new.call(params)
      unless result.success?
        raise ContractError.new(result.errors.to_h)  
      end
    end

    
  end
end