# frozen_string_literal: true

RSpec.describe FreshJwt::Entity::AccessToken do
  let(:token) { SecureRandom.hex }
  let(:access_token) { FreshJwt::Entity::AccessToken.new(token: token) }
  before do
    
  end
  it 'create access token klass' do
    expect(access_token.name).to eq('AccessToken')
  end
end