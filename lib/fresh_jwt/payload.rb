


module FreshJwt

  module Entity
    module Callable
      def call(*args)
        new(*args)
      end
  
      alias [] call
    end
  end

  class Payload
    extend Dry::Initializer
    extend Entity::Callable
  
    option :jti, default: proc { SecureRandom.hex }
    option :iat, proc(&:to_i), default: proc { Time.now }
    option :exp, ->(val){ (Time.now + val).to_i }, default: -> { 10 * 60 } #default: ->(val) { iat + 10*60 }
    option :extend, proc(&:to_h), default: proc{ {} }
    
    def default_payload
      @default_payload ||= self.class.dry_initializer.attributes(self).slice(:jti, :iat, :exp)
    end

    def to_hash
      @params ||= default_payload.merge(extend)
    end

  end
end

=begin
def registered_claim(sym)
  case sym
  when :aud then Claim::Aud
  when :exp then Claim::Exp
  when :iat then Claim::Iat
  when :iss then Claim::Iss
  when :jti then Claim::Jti
  when :nbf then Claim::Nbf
  when :sub then Claim::Sub
  else nil # custom claim
  end
end
=end
