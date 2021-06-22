require_relative 'store/mixin'
require_relative 'store/decorator'
require_relative 'store/memory'

module FreshJwt  

  module Store
    
    #require 'singleton'
    @@repo = nil
    def self.repo= repo
      # TODO add check repo needed methods
      @@repo = Store::Decorator.new(repo)
      
    end

    def self.repo
      @@repo
    end
  end
end
