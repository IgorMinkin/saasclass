class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end
  
  def show
    id = params[:id]
    @movie = Movie.find_by_id(id)
  end
  
  def new
  end
  
  def create
    debugger
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "Movie #{@movie.title} was successfully created."
  end
end