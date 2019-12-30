RSpec.describe ContaAzulApi::Product do
  before do
    ContaAzulApi::Helpers.stub_refresh_token

    stub_const('CaAuthHistory', FakeCaAuthHistory)

    logger = double(:logger, info: '')
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe '.find' do
    it 'returns a product when a valid ID is provided' do
      ContaAzulApi::Helpers.stub_product(
        id: 'c7288c09-829d-48b9-aee2-4f744e380587',
        data: JSON.parse(File.read('spec/fixtures/products_endpoints/find_by_id.json'))
      )

      product = ContaAzulApi::Product.find('c7288c09-829d-48b9-aee2-4f744e380587')

      expect(product.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
      expect(product.name).to eq('Game Atari ET')
    end

    it 'raises an error when product not found' do
      ContaAzulApi::Helpers.stub_product(id: 'c7288c09-829d-48b9-aee2-4f744e380587', status: 404)

      expect {
        ContaAzulApi::Product.find('c7288c09-829d-48b9-aee2-4f744e380587')
      }.to raise_exception(ContaAzulApi::Product::NotFound)
    end
  end

  describe '.all' do
    it 'returns all products' do
      ContaAzulApi::Helpers.stub_list_products(
        status: 200,
        products: JSON.parse(File.read('spec/fixtures/products_endpoints/list_all.json'))
      )

      products = ContaAzulApi::Product.all

      expect(products.size).to eq(1)
    end
  end

  describe '.filter_by' do
    it 'returns all products filtered by name' do
      ContaAzulApi::Helpers.stub_list_products(
        status: 200,
        products: JSON.parse(File.read('spec/fixtures/products_endpoints/list_all.json'))
      )

      products = ContaAzulApi::Product.filter_by(name: 'Game')

      expect(products.size).to eq(1)
      expect(products.first.name).to eq('Game Atari ET')
    end
  end
end
