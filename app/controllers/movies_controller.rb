class MoviesController < ApplicationController
  def index
    if params[:sort_col].nil? || !Movie.column_names.any? { |col| col == params[:sort_col] } 
      return @movies = Movie.all
    end
    
    sort_col = params[:sort_col]
    sort_dir = ['asc','desc'].find_index(params[:sort_dir]).nil? ? 'asc' : params[:sort_dir]
    flash[:sort_col] = sort_col
    flash[:sort_dir] = sort_dir == 'asc' ? 'desc' : 'asc'
    flash[:selected_col_style] = 'hilite'
    @movies = Movie.all(:order => sort_col + ' ' + sort_dir)
  end
  
  def show
    id = params[:id]
    @movie = Movie.find_by_id(id)
  end
  
  def new
  end
  
  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "Movie #{@movie.title} was successfully created."
    redirect_to movies_path
  end
  
  def edit
    @movie = Movie.find params[:id]
  end
  
  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end