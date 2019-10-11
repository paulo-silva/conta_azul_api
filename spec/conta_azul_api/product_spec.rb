RSpec.describe ContaAzulApi::Product do
  before do
    stub_request(:post, %r{https://api.contaazul.com/oauth2/token}).
      to_return(status: 200, body: File.read('spec/fixtures/refresh_oauth_token.json'))

    stub_const('CaAuthHistory', FakeCaAuthHistory)

    logger = double(:logger, info: '')
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe '.find' do
    it 'returns a product when a valid ID is provided' do
      stub_request(:get, 'https://api.contaazul.com/v1/products/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 200, body: File.read('spec/fixtures/products_endpoints/find_by_id.json'), headers: {})

      product = ContaAzulApi::Product.find('c7288c09-829d-48b9-aee2-4f744e380587')

      expect(product.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
      expect(product.name).to eq('Game Atari ET')
    end

    it 'raises an error when product not found' do
      stub_request(:get, 'https://api.contaazul.com/v1/products/c7288c09-829d-48b9-aee2-4f744e380587').
        to_return(status: 404)

      expect {
        ContaAzulApi::Product.find('c7288c09-829d-48b9-aee2-4f744e380587')
      }.to raise_exception(ContaAzulApi::Product::NotFound)
    end
  end

  describe '.all' do
    it 'returns all products' do
      stub_request(:get, %r{https://api.contaazul.com/v1/products}).
        to_return(status: 200, body: File.read('spec/fixtures/products_endpoints/list_all.json'), headers: {})

      products = ContaAzulApi::Product.all

      expect(products.size).to eq(1)
    end
  end

  describe '.filter_by' do
    it 'returns all products filtered by name' do
      stub_request(:get, %r{https://api.contaazul.com/v1/products}).
        to_return(status: 200, body: File.read('spec/fixtures/products_endpoints/list_all.json'), headers: {})

      products = ContaAzulApi::Product.filter_by(name: 'Game')

      expect(products.size).to eq(1)
      expect(products.first.name).to eq('Game Atari ET')
    end
  end
end
