# frozen_string_literal: true
# кажется причина ошибок в спеках в том, что Memory obj шарится в разных местах
# нужно видимо делать instance_double()
include Dry::Monads[:result]
RSpec.describe FreshJwt::Refresher do
  let(:unknown_token) { 'unknown_token' }
  let(:token) { SecureRandom.uuid }

  let(:repo) { FreshJwt::Store::Memory.new }
  before do
    FreshJwt::Store.repo = repo
    FreshJwt::Store.repo.single_transaction token
  end
  it 'have not found a token' do
    expect(described_class.new.call(unknown_token)).to be_failure
  end

  context 'when add token to store' do
    #before do
      
    #end
    it 'retuns success with token' do
      expect(described_class.new.call(token)).to be_success
    end
  end

  context 'when invalid by differents reason' do
    let(:subject) {described_class.new.call(token)}
    before do
      t = Time.at( Time.now.to_i + FreshJwt::Expiration::ACCESS + 1 )
      Timecop.travel(t)    
    end
    it 'should return failure object coz token has expire' do
      expect(subject).to be_failure
    end

    it 'should return concrete error coz token has expire' do
      expect(subject.failure).to eq(error: described_class::TokenExpiredError.new)
    end
    
  end


end