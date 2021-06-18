require_relative 'lib/fresh_jwt'

#payload = FreshJwt::Payload.new(extend:{
#  user_id: rand(1000),
#  rating: 99.4
#})

payload = {
  user_id: rand(1000),
  rating: 99.4
}

issuer = FreshJwt::Issuer.new(algorithm: 'HS256', payload:payload)

access_token, refresh_token = begin
  issuer.call
rescue FreshJwt::ContractError => e
  p e.message
  nil
end
token = access_token.token

exit(0) unless token
p token 
p "decoded " << FreshJwt::Decoder.new().decode(token:token).to_s 
#p JWT.decode(token, issuer.secret, 'HS256')
p "valid? " << FreshJwt::Validator.new().call(token).to_s
payload = FreshJwt::Payload.new({})
p "store: #{FreshJwt::Store.all}"


########################################
##### HOW TO COMFORTABLE WORK WITH #####
########################################
=begin
issuer = FreshJwt::Issuer.new(algorithm: 'HS256')
#OR
issuer = FreshJwt::Issuer.new
access, refresh = issuer.call(payload: {
  user_id: 1
})

authenticator = FreshJwt::Authenticator.new
authenticator.call(access_token: token)
# Success or 403 failure with errors describe

refresher = FreshJwt::Refresher.new
access, refresh = refresher.call(
  refresh_token: token,
  payload: {
    user_id: 1
  }
)
=end
#FreshJwt::Revoker









