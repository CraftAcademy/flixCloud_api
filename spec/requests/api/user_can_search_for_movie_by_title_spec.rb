# frozen_string_literal: true

RSpec.describe Api::MoviesController, type: :request do
  let!(:registered_user) { create(:user) }
  let!(:authorization_headers) { registered_user.create_new_auth_token }

  describe 'Search for a movie by title' do

    before do
      get '/api/movies/search',
        params: { query: 'Christmas' },
        headers: authorization_headers 
    end
    
    it {
      expect(response).to have_http_status 200
    }
  end
end