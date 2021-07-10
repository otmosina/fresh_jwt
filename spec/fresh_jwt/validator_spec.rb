# frozen_string_literal: true

RSpec.describe FreshJwt::Validator do
  #let(:token) { SecureRandom.hex }
  #let(:access_token) { FreshJwt::Entity::AccessToken.new(token: token) }
  let(:random_token) { SecureRandom.hex }
  before do
    @access_token, @refresh_token = FreshJwt::Issuer.new(payload: {}).call()
    #FreshJwt::Store.save access_token
  end
  it 'can validate coz knwon token' do
    expect(described_class.new.call(@access_token.token)).to eq(Success())
  end

  it 'con not validate coz unknwon token' do
    expect(described_class.new.call(random_token)).to be_failure
  end
  context 'too late for validate' do
    before do
      @access_token, @refresh_token = FreshJwt::Issuer.new(payload: {}).call()
      t = Time.at( Time.now.to_i + FreshJwt::Expiration::ACCESS + 1 )
      Timecop.travel(t)   
    end
    it 'can not validate coz expire token' do
      expect(described_class.new.call(@access_token.token)).to eq(
        Failure({:decode_error=>["Cannot validate", "Signature has expired"]})
      )
    end
  end
end

# Добавить кейсы с разными фейлами
# -Failure({:decode_error=>"Signature has expired"})
# +Failure({:decode_error=>"Signature verification raised"})