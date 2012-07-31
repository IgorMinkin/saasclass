class MoviesController < ApplicationController
  def index
    @sort_col = get_sort_col
    @sort_dir = get_sort_dir
    @rating_filter = get_ratings_filter
    
    if @redirect_flag
      flash.keep
      redirect_to movies_path(:sort_col => @sort_col, :sort_dir => @sort_dir, :ratings => @rating_filter)
    end
    
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
  
  private
  
  def get_sort_col
    if !params[:sort_col].nil?
      session[:sort_col] = params[:sort_col]
    else
      @redirect_flag = !session[:sort_col].nil? unless session[:sort_col].nil?
    end
    session[:sort_col]
  end
  
  def get_sort_dir
    if !params[:sort_dir].nil?
      session[:sort_dir] = ['asc','desc'].find_index(params[:sort_dir]).nil? \
          ? 'asc' : params[:sort_dir]
    else
      @redirect_flag = !session[:sort_dir].nil? unless session[:sort_dir].nil?
      session[:sort_dir] = session[:sort_dir] || 'asc'
    end
    session[:sort_dir]
  end
  
  def get_ratings_filter
    if !params[:ratings].nil? || params[:commit] == 'Refresh'
      session[:ratings] = params[:ratings].nil? ? {} : params[:ratings].select { |k,v| v == '1' } 
      if params[:commit] == 'Refresh' then @redirect_flag = true end
    else
      session[:ratings] = {} if session[:ratings].nil?
      if !session[:ratings].empty? && params[:ratings].nil? then @redirect_flag = true end
    end
    return session[:ratings]
  end
end