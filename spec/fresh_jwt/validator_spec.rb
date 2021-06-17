# frozen_string_literal: true

RSpec.describe FreshJwt::Validator do
  let(:token) { SecureRandom.hex }
  let(:access_token) { FreshJwt::Entity::AccessToken.new(token: token) }
  before do
    FreshJwt::Store.save access_token
  end
  it 'can validate coz knwon token' do
    expect(described_class.new.call(access_token.token)).to eq(true)
  end

  context 'too late for validate' do
    before do
      t = Time.at( Time.now.to_i + FreshJwt::Expiration::ACCESS + 1 )
      Timecop.travel(t)   
    end
    it 'can not validate coz expire token' do
      expect(described_class.new.call(access_token.token)).to eq(false)
    end
  end
end