# frozen_string_literal: true

RSpec.describe FreshJwt::Entity::AccessToken do
    let(:token) { SecureRandom.hex }
    let(:access_token) { FreshJwt::Entity::AccessToken.new(token: token) }
    let(:refresh_token) { FreshJwt::Entity::RefreshToken.new(token: token) }
    
    before do
      
    end
    it 'create access token klass' do
      expect(access_token.name).to eq('AccessToken')
    end

    it 'return false coz access not expire' do
      expect(access_token.expired?).to be_falsey
    end
    it 'return false coz refresh not expire' do
      expect(refresh_token.expired?).to be_falsey
    end     

    context 'when future time & token has expired' do
      before do
        access_token
        refresh_token
        future_time = Time.now.to_i + FreshJwt::Expiration::REFRESH + 1
        Timecop.travel(Time.at(future_time))
      end
      it 'return true coz access expired' do
        expect(access_token.expired?).to be_truthy
      end
      it 'return true coz refresh expired' do
        expect(refresh_token.expired?).to be_truthy
      end 
    end
  end