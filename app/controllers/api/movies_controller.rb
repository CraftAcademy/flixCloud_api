class Api::MoviesController < ApplicationController
  API_KEY = Rails.application.credentials.moviedb[:api_key]
  API_URL = 'https://api.themoviedb.org/3'
  API_IMAGE_URL = "https://image.tmdb.org/t/p/w500"

  before_action :authenticate_user!, only: %i[search]

  def index
    result =
      RestClient.get(
        "#{API_URL}/discover/movie",
        params: {
          api_key: API_KEY,
          language: 'en-US',
          sort_by: 'popularity.desc',
          include_adult: 'false',
          page: '1'
        }
      )
    body = JSON.parse(result.body)
    movies = sanitized_movies(body)

    render json: { movies: movies }, status: 200
  end

  def search
    if params[:query] == nil
      render json: { message: 'You need to fill in the search form' },
             status: 422
    else
      result =
        RestClient.get(
          "#{API_URL}/search/movie",
          params: {
            api_key: API_KEY,
            language: 'en-US',
            query: params[:query],
            include_adult: 'false',
            page: '1'
          }
        )
      body = JSON.parse(result.body)
      movies = sanitized_movies(body)
      render json: { movies: movies }, status: 200
    end
  end

  def image
    redirect_to image_url(params[:id])
  end

  private

  def sanitized_movies(body)
    sanitized_movies = []
    array = body['results']
    array.each { |movie| sanitized_movies.push format_movie(movie) }
    sanitized_movies
  end

  def format_movie(movie)
    {
      title: movie['title'],
      release_date: movie['release_date'],
      poster_path: image_path(movie['poster_path'])
    }
  end

  def image_path(path)
    "/api/movies/image#{path}"
  end

  def image_url(id)
    "#{API_IMAGE_URL}/#{id}.jpg"
  end
end
