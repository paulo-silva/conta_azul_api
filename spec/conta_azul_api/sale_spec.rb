RSpec.describe ContaAzulApi::Sale do
  before do
    stub_request(:post, %r{https://api.contaazul.com/oauth2/token}).
      to_return(status: 200, body: File.read('spec/fixtures/refresh_oauth_token.json'))

    stub_const('CaAuthHistory', FakeCaAuthHistory)

    logger = double(:logger, info: '')
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe '.create' do
    it 'creates a sale when valid data is provided' do
      sales_params = {
        number: 1234,
        emission: '2019-12-27T16:55:06.343Z',
        status: 'COMMITTED',
        customer_id: 'c7288c09-829d-48b9-aee2-4f744e380587',
        products: [
          {
            description: "Game Atari ET",
            quantity: 2,
            product_id: "f8ffb77a-3d52-42d7-9bec-ea38c0ef043d",
            value: 50
          }
        ],
        payment: {
          type: 'CASH'
        },
        notes: 'PP2'
      }

      stub_request(:post, 'https://api.contaazul.com/v1/sales').
        with(body: sales_params).
        to_return(status: 201, body: File.read('spec/fixtures/sales_endpoints/create.json'), headers: {})

      new_sale = ContaAzulApi::Sale.create(sales_params.as_json)

      expect(new_sale.id).to eq('c7288c09-829d-48b9-aee2-4f744e380587')
    end

    it 'raises error when sale is not created' do
      stub_request(:post, 'https://api.contaazul.com/v1/sales').
        with(body: {}).
        to_return(status: 422, body: nil, headers: {})

      expect {
        ContaAzulApi::Sale.create({}.as_json)
      }.to raise_exception(ContaAzulApi::Sale::NotCreated)
    end
  end
end
