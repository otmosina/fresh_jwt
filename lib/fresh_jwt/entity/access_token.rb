module FreshJwt
  module Entity

    class Token
      extend Dry::Initializer
      option :name, proc(&:to_s), default: -> { 'access' }
      option :token, proc(&:to_s)
      option :issued_at, proc(&:to_i), default: -> { Time.now.to_i }
    end

    class AccessToken < Token
      extend Dry::Initializer

      option :name, proc(&:to_s), default: -> { 'access' }
      option :payload, Payload, optional: true
    end

    class RefreshToken < Token
      option :name, proc(&:to_s), default: -> { 'refresh' }
    end


  end
end