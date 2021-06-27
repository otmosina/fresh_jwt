# frozen_string_literal: true

module FreshJwt
  module Configure
    @@access_lifetime = Expiration::ACCESS
    @@refresh_lifetime = Expiration::REFRESH
    def configure
      yield self
    end

    def access_lifetime
      @@access_lifetime
    end

    def access_lifetime= access_lifetime
      @@access_lifetime = access_lifetime 
    end
    
    def refresh_lifetime
      @@refresh_lifetime
    end

    def refresh_lifetime= refresh_lifetime
      @@refresh_lifetime = refresh_lifetime 
    end
  end
end