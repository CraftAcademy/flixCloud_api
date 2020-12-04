class Api::MoviesController < ApplicationController
  API_KEY = Rails.application.credentials.moviedb[:api_key]  
  API_URL = "https://api.themoviedb.org/3"

  before_action :authenticate_user!, only: [:search]

  def index
    result = RestClient.get("#{API_URL}/discover/movie", params: 
      {api_key: API_KEY, language: "en-US", sort_by: "popularity.desc", include_adult: "false", page: "1"})
    body = JSON.parse(result.body)
    movies = sanitized_movies(body)  

    render json: { movies: movies }, status: 200
  end

  def search
    render json: {}
  end

  private

  def sanitized_movies(body)
    sanitized_movies = []
    array = body["results"]
    array.each do |movie|
      sanitized_movies.push format_movie(movie)
    end
    sanitized_movies
  end

  def format_movie(movie)
    {
      title: movie["title"],
      release_date: movie["release_date"],
      poster_path: movie["poster_path"]
    }
  end
end
