
shared_examples FreshJwt::Entity::Token do# do |token:, type:|
  context 'do' do
    let(:name) { type.capitalize.to_s << "Token"  }
    it 'has attribute name' do
      expect(token.name).to eq(name)
    end
    it 'has attribute token' do
      expect(token.name).to be_kind_of(String)
    end
    it 'has time attributes token' do
      expect(token.expired_at).to be_kind_of(Integer)
      expect(token.issued_at).to be_kind_of(Integer)
    end  
  end  
end
  