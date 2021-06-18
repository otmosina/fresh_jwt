module FreshJwt

  class Issuer
    extend Dry::Initializer
    include Dry::Monads[:result, :do]
    REFRESH_EXPIRATION = 60*60*24

    #Payload.new(extend: val )
    option :payload, ->(hash){ Payload.new(extend: hash) }, default: -> { Payload.new } #why we need new i do not understand, coz class is callable
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
      
      yield tokens_repo.single_transaction access_token
      yield tokens_repo.single_transaction refresh_token
      
      #result = tokens_repo.transaction do
      #  tokens_repo.save access_token
      #  tokens_repo.save refresh_token
      #end
      #return result unless result.success?

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