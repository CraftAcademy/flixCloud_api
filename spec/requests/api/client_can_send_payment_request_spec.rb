RSpec.describe 'POST /api/subscriptions', type: :request do
  describe 'successfully' do
    let!(:user) { create(:user) }
    let!(:user_headers) { user.create_new_auth_token }

  before do

    post '/api/subscriptions',
      params: { 
        stripetoken: StripeMock.create_test_helper.generate_card_token
      },
      headers: user_headers
  end

  it 'is expected to return 200 respons' do
    expect(response).to have_http_status 200
  end

  it 'is expected to return a success message' do
    expect(response_json['message']).to eq 'Thank you for your payment, you are now a subscriber!'
  end

  it 'is expected to turn user into subscriber' do
    expect(user.reload.subscriber).to eq true
  end
end
end