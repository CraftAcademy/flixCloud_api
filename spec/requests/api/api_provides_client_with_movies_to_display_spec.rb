# frozen_string_literal: true

RSpec.describe Api::MoviesController, type: :request do
  describe 'successfully GET a collection of movies' do

    before do
      get '/api/movies'
    end

    it 'is expected to return a 200 response' do
      expect(response).to have_http_status 200
    end

    it 'is expected to return twenty movies' do
      expect(response_json['movies'].count).to eq 20
    end

    it 'is expected to have movie title in \'movies\'' do
      expect(response_json['movies'].first['title'])
      .to eq "Chick Fight"
    end

    it 'is expected to have release date in \'movies\'' do
      expect(response_json['movies'].second['release_date'])
      .to eq "2020-10-23"
    end

    it 'is expected to have movie poster in \'movies\'' do
      expect(response_json['movies'].third['poster_path'])
      .to eq "/api/movies/image/sp4zXS3x4wHyL8wm8zLioiBrxuR.jpg"
    end
  end
end