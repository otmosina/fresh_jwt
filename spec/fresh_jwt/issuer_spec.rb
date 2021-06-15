

RSpec.describe FreshJwt::Issuer do
  let(:jwt_regexp) { /^[\w-]*\.[\w-]*\.[\w-]*$/ }
  let(:plain_token) { 'Token' }
  let(:secret) { SecureRandom.hex }
  let(:user_id) { rand(1000) }
  let(:payload) { FreshJwt::Payload.new(extend:{user_id:user_id})}
  let(:issuer) { described_class.new(payload: payload) }
  before do
    allow(SecureRandom).to receive(:hex).and_return(plain_token)
  end
  it 'should be kind of string' do
    expect(issuer.call).to be_kind_of String
  end
  it 'match jwt_regexp' do
    expect(issuer.call).to match jwt_regexp
  end  

end
