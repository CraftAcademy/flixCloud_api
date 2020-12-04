# frozen_string_literal: true

RSpec.describe Api::MoviesController, type: :request do
  let!(:registered_user) { create(:user) }
  let!(:authorization_headers) { registered_user.create_new_auth_token }

  describe 'Search for a movie by title' do
    context 'When users provide query params' do
      before do
        fixture_file =
          File.open("#{::Rails.root}/spec/fixtures/movies_search.json").read
        query = 'christmas'
        stub_request(
          :get,
          "https://api.themoviedb.org/3/search/movie?api_key=#{
            Rails.application.credentials.moviedb[:api_key]
          }&language=en-US&query=#{query}&page=1&include_adult=false"
        ).to_return(status: 200, body: fixture_file, headers: {})

        get '/api/movies/search',
            params: { query: query }, headers: authorization_headers
      end

      it 'is expected to return a 200 response' do
        expect(response).to have_http_status 200
      end

      it 'is expected to return twenty movies' do
        expect(response_json['movies'].count).to eq 20
      end

      it 'is expected to have movie title in \'movies\'' do
        expect(
          response_json['movies'].first['title']
        ).to eq 'The Christmas Chronicles: Part Two'
      end

      it 'is expected to have release date in \'movies\'' do
        expect(
          response_json['movies'].second['release_date']
        ).to eq '2020-11-05'
      end

      it 'is expected to have movie poster in \'movies\'' do
        expect(
          response_json['movies'].third['poster_path']
        ).to eq '/eu747ko823mktL3ygo7ohdZznP7.jpg'
      end
    end
  end

  context 'When users do not provide query params' do
    before { get '/api/movies/search', headers: authorization_headers }

    it 'is expected to return a 422 response' do
      expect(response).to have_http_status 422
    end

    it 'is expected to return error message' do
      expect(response_json['message']).to eq 'You need to fill in the search form'
    end
  end
end
