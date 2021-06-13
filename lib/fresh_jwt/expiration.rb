module FreshJwt
  module Expiration
    def self.minutes v
      v * 60
    end
    ACCESS = Expiration.minutes(5) 
    REFRESH = Expiration.minutes(60)
  end
end
