RSpec.describe 'POST /api/subscriptions', type: :request do
  describe 'successfully' do
    let!(:user) { create(:user) }
    let!(:user_headers) { user.create_new_auth_token }

  before do
    post '/api/api/subscriptions',
      params: { 
        stripetoken: "12345"
      },
      headers: user_headers
  end

  it 'is expected to return 200 respons' do
    expect(response).to have_http_status 200
  end

  it 'is expected to return a success message' do
    expect(response_json)['message'].to eq 'Thank you for your payment, you are now a subscriber'
  end

  it 'is expected to turn user into subscriber' do
    expect(user.subscriber).to eq true
  end
end
end