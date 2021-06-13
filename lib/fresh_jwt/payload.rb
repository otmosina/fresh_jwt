
module Entity
  module Callable
    def call(*args)
      new(*args)
    end

    alias [] call
  end
end

module FreshJwt
  class Payload
    extend Dry::Initializer
    extend Entity::Callable
  
    option :jti, default: proc { SecureRandom.hex }
    option :iat, proc(&:to_i), default: proc { Time.now }
    option :exp, proc(&:to_i), default: -> { iat + 10*60 } #default: ->(val) { iat + 10*60}
    option :user_id, proc(&:to_i), optional: true
  
    def params_to_hash
      @params ||= self.class.dry_initializer.attributes(self)
    end
  end
end