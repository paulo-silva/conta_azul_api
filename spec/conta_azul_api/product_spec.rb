RSpec.describe ContaAzulApi::Product do
  describe '.find' do
    it 'returns a product when a valid ID is provided' do
      stub_request(:get, 'https://api.contaazul.com/v1/products/21579900-b3ae-4e59-b2c0-5cac5cff6fbd').
        to_return(status: 200, body: File.read('spec/fixtures/products_endpoints/find_by_id.json'), headers: {})

      product = ContaAzulApi::Product.find('21579900-b3ae-4e59-b2c0-5cac5cff6fbd')

      expect(product.id).to eq('21579900-b3ae-4e59-b2c0-5cac5cff6fbd')
      expect(product.name).to eq('Batom Ester')
    end

    it 'raises an error when product not found' do
      stub_request(:get, 'https://api.contaazul.com/v1/products/21579900-b3ae-4e59-b2c0-5cac5cff6fbd').
        to_return(status: 404)

      expect {
        ContaAzulApi::Product.find('21579900-b3ae-4e59-b2c0-5cac5cff6fbd')
      }.to raise_exception(ContaAzulApi::Product::NotFound)
    end
  end

  describe '.all' do
    it 'returns all products' do
      stub_request(:get, %r{https://api.contaazul.com/v1/products}).
        to_return(status: 200, body: File.read('spec/fixtures/products_endpoints/list_all.json'), headers: {})

      products = ContaAzulApi::Product.all

      expect(products.size).to eq(103)
    end
  end

  describe '.filter_by' do
    it 'returns all products filtered by name' do
      stub_request(:get, %r{https://api.contaazul.com/v1/products}).
        to_return(status: 200, body: File.read('spec/fixtures/products_endpoints/list_all.json'), headers: {})

      products = ContaAzulApi::Product.filter_by(name: 'Batom')

      expect(products.size).to eq(2)
      expect(products.first.name).to eq('Batom Ester')
      expect(products.last.name).to eq('Batom Realnude')
    end
  end
end
