class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #if request.env['PATH_INFO'] == '/'
    #  session.clear
    #end
    @all_ratings = Movie.all_ratings
    @initRatings = {}
    @all_ratings.each{ |rating| @initRatings[rating] = 1 }
    @movies = Movie.all
    
    if params[:ratings]
      @initRatings = params[:ratings]
      session[:ratings] = @initRatings
    elsif session[:ratings] 
      @initRatings = session[:ratings]
    end
    
    sort_order = params[:sort] || session[:sort]
    if sort_order == 'title'
      @movies = @movies.order(:title)
      session[:sort] = 'title'
    elsif sort_order == 'release_date'
      @movies = @movies.order(:release_date)
      session[:sort] = 'release_date'
    else
      sort_order = ''
    end
    
    @movies = @movies.with_ratings(@initRatings.keys)
    if !params[:ratings] and session[:ratings]
      if flash[:warning] || flash[:notice]
        flash.keep
      end
      redirect_to movies_path(:sort => sort_order,:ratings => @initRatings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
