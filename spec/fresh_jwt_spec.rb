RSpec.describe FreshJwt do 
  it 'has a version number' do
    expect(described_class::VERSION).not_to be_nil
  end

  it 'has default access lifetime' do
    expect(described_class.access_lifetime).not_to be_nil
  end

  it 'has default refresh lifetime' do
    expect(described_class.refresh_lifetime).not_to be_nil
  end  
end