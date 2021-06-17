Struct.new('AccessToken', :token)

RSpec.describe FreshJwt::Store do
  let(:token) { SecureRandom.hex }
  let(:unknown_token) { SecureRandom.hex }
  let(:token_obj) { Struct::AccessToken.new(token) }
  before do 
    described_class.save token_obj 
  end
  it 'should contant token' do
    expect(described_class.find_by_token(token)).to eq(token_obj)
  end
  it 'should not contant token' do
    expect(described_class.find_by_token(unknown_token)).to be_nil
  end  
end