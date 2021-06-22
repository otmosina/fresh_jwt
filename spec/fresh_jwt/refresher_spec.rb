# frozen_string_literal: true

RSpec.describe FreshJwt::Refresher do
  let(:unknown_token) { 'unknown_token' }
  let(:token) { SecureRandom.uuid }
  let(:repo) { FreshJwt::Store::Memory.new }
  before do
    FreshJwt::Store.repo = repo
  end
  xit 'have not found a token' do
    expect(described_class.new.call(unknown_token)).to be_failure
  end

  context 'when add token to store' do
    before do
      FreshJwt::Store.repo.single_transaction token
    end
    it 'retuns success with token' do
      expect(described_class.new.call(token)).to be_success
    end    
  end

end