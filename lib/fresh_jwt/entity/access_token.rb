module FreshJwt
  module Entity

    class Token
      extend Dry::Initializer
      option :name, proc(&:to_s), default: -> { self.class.to_s.split('::').last }
      option :token, proc(&:to_s)
      option :issued_at, proc(&:to_i), default: -> { Time.now.to_i }
    end

    class AccessToken < Token
      option :payload, Payload, optional: true
    end

    class RefreshToken < Token
      #https://auth0.com/docs/tokens/refresh-tokens/disable-refresh-token-rotation
      option :behavior_type, proc(&:to_s), default: -> {'non-rotation'} #or rotation
    end


  end
end