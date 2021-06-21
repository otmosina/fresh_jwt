# frozen_string_literal: true

RSpec.describe FreshJwt::Store do
  let(:repo) { FreshJwt::Store::Memory.new }
  before do
    described_class.repo = repo
  end
  it 'return correct repo' do
    expect(described_class.repo).to eq(repo)
  end

  it 'reponds true for repo.save call' do
    expect(described_class.repo.respond_to?(:save)).to eq(true)
  end

  it 'reponds true for repo.find_by_token' do
    expect(described_class.repo.respond_to?(:find_by_token)).to eq(true)
  end
  
  it 'reponds true for repo.single_transaction' do
    expect(described_class.repo.respond_to?(:single_transaction)).to eq(true)
  end  
end