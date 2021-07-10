
RSpec.describe FreshJwt::Issuer do
  
  let(:jwt_regexp) { /^[\w-]*\.[\w-]*\.[\w-]*$/ }
  let(:plain_token) { 'Token' }
  let(:secret) { SecureRandom.hex }
  let(:user_id) { rand(1000) }
  let(:payload) { {user_id:user_id} }
  let(:issuer) { described_class.new(payload: payload) }
  before do
    allow(SecureRandom).to receive(:hex).and_return(plain_token)
  end
  it 'SecureRandom always return same value' do
    expect(SecureRandom).to receive(:hex).and_return(plain_token)
    issuer.call
  end
  it 'should be kind of string' do
    expect(issuer.call).to be_kind_of Array
  end
  it 'return AccessToken as first value' do
    expect(issuer.call.first).to be_kind_of FreshJwt::Entity::AccessToken
  end
  it 'return RefreshToken as first value' do
    expect(issuer.call.last).to be_kind_of FreshJwt::Entity::RefreshToken
  end    
  it 'match jwt_regexp' do
    expect(issuer.call.first.token).to match jwt_regexp
  end 
  #let(:store) { class_double(FreshJwt::Store)}
  context 'store transaction is failed' do
    before do
      allow(issuer.tokens_repo).to receive(:save).and_raise(StandardError)
      #allow(FreshJwt::StoreOld).to receive(:save).and_raise(StandardError)
    end
    it 'return empty array' do
      expect(issuer.call).to be_failure
    end
  end

  context 'check correct access token objects' do
    let(:type) { :access }
    let(:token) { issuer.call.first }
    it_behaves_like FreshJwt::Entity::Token
  end

  context 'check correct refresh token objects' do
    let(:type) { :refresh }
    let(:token) { issuer.call.last }
    it_behaves_like FreshJwt::Entity::Token
  end  

end
