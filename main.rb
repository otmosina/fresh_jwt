require_relative 'lib/fresh_jwt'

payload = FreshJwt::Payload.new(extend:{
  user_id: rand(1000),
  rating: 99.4
}) 
issuer = FreshJwt::Issuer.new(algorithm: 'HS256', payload:payload)

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
