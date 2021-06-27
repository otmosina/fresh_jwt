module FreshJwt
  class TokenExpiredError < StandardError; end

  class TokenObjectError < StandardError
    DEFAULT_MESSAGE = 'Token object has wrong structure for Tokens store'
    def initialize(msg = DEFAULT_MESSAGE, exception_type='token')
      @exception_type = exception_type
      super(msg)
    end
  end

  class ContractError < StandardError
    DEFAULT_MESSAGE = 'something wrong with Contract'
    def initialize(msg = DEFAULT_MESSAGE, exception_type='custom')
      @exception_type = exception_type
      super(msg) 
    end
    def message
      super
    end
  end  

end