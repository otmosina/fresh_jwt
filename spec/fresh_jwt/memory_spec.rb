Struct.new('TokenObject', :token, :expiration)
include Dry::Monads[:result]

RSpec.describe FreshJwt::Memory do
  let(:memory_store) { FreshJwt::Store::Decorator.new(FreshJwt::Memory.new) }
  let(:wrong_token_object) { SecureRandom.hex }
  let(:correct_token_object) { Struct::TokenObject.new }

  it 'return error when token object incorrect' do
    expect{memory_store.save(wrong_token_object)}.to raise_error(FreshJwt::Store::Decorator::TokenObjectError)
  end

  it 'return true coz token struct is ok' do
    expect(memory_store.save(correct_token_object)).to be_truthy
  end

  describe '.find_by_token' do
    before do
      memory_store.save(correct_token_object)
    end

    it 'return correct token object' do
      expect(memory_store.find_by_token(correct_token_object.token)).to eq(correct_token_object)
    end

    it 'return nil coz token didnt save before' do
        expect(memory_store.find_by_token('token')).to be_nil
    end
  end

  describe 'single_transaction mixin' do
    before do
      memory_store.class.send(:include, FreshJwt::Store::Mixin)    
    end
    it 'returns Success monad' do      
      expect(memory_store.single_transaction(correct_token_object)).to be_kind_of(Success)
    end

    it 'can find token after save via single transaction' do
      memory_store.single_transaction(correct_token_object)
      expect(memory_store.find_by_token(correct_token_object.token)).to eq(correct_token_object)
    end
  end

  #it_behaves_like 'single_transaction mixin'

  describe 'use delegator for Decorate Store' do
    let(:memory_store_decorated) {FreshJwt::Store::Decorator.new(memory_store)}
    it 'returns Success monad' do
      expect(memory_store_decorated.single_transaction(correct_token_object)).to be_kind_of(Success)
    end
  
    it 'can find token after save via single transaction' do
      memory_store_decorated.single_transaction(correct_token_object)
      expect(memory_store_decorated.find_by_token(correct_token_object.token)).to eq(correct_token_object)
    end    
  end
end