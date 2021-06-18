# frozen_string_literal: true
include Dry::Monads[:result]
RSpec.describe FreshJwt::Validator do
  #let(:token) { SecureRandom.hex }
  #let(:access_token) { FreshJwt::Entity::AccessToken.new(token: token) }
  
  before do
    @access_token, @refresh_token = FreshJwt::Issuer.new(payload: {}).call()
    #FreshJwt::Store.save access_token
  end
  it 'can validate coz knwon token' do
    expect(described_class.new.call(@access_token.token)).to eq(Success())
  end

  context 'too late for validate' do
    before do
      @access_token, @refresh_token = FreshJwt::Issuer.new(payload: {}).call()
      t = Time.at( Time.now.to_i + FreshJwt::Expiration::ACCESS + 1 )
      Timecop.travel(t)   
    end
    it 'can not validate coz expire token' do
      expect(described_class.new.call(@access_token.token)).to eq(Failure({:decode_error=>"Signature has expired"}))
    end
  end
end