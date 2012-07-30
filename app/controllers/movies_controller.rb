class MoviesController < ApplicationController
  def index
    @sort_col = params[:sort_col]
    @sort_dir = ['asc','desc'].find_index(params[:sort_dir]).nil? \
        ? 'asc' : params[:sort_dir]
    @rating_filter = !params[:ratings].nil? \
        ? params[:ratings].select { |k,v| v == '1' } : {}
    @all_ratings = Movie.ratings
    @movies = Movie
    
    #sort
    if Movie.valid_column?(@sort_col)
      @movies = @movies.order("#{@sort_col} #{@sort_dir}")
      @sort_dir = @sort_dir == 'asc' ? 'desc' : 'asc'
    end
    
    #filter
    if !@rating_filter.empty?
      @movies = @movies.where(:rating => @rating_filter.keys)
    end
    @movies = @movies.all
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