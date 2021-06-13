require_relative 'lib/fresh_jwt'

issuer = FreshJwt::Issuer.new(algorithm: 'HS256') 
token = begin
  issuer.call
rescue FreshJwt::ContractError => e
  p e.message
  nil
end
exit(0) unless token
p token 
p JWT.decode(token, issuer.secret, 'HS256')

payload = FreshJwt::Payload.new({})
