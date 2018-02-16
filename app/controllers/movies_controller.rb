class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @redirect = false

    if(@checked != nil)
      @movies = @movies.find_all{ |m| @checked.has_key?(m.rating) and  @checked[m.rating]==true}      
    end

    if params[:sort].to_s == 'title'
      session[:sort] = params[:sort]
      @movies = @movies.sort_by{|m| m.title}
    elsif params[:sort].to_s == 'release'
      session[:sort] = params[:sort]
      @movies = @movies.sort_by{|m| m.release_date.to_s }
    elsif session.has_key?(:sort)
      params[:sort] = session[:sort]
      @redirect = true
    end

    if(params[:ratings] != nil)
      session[:ratings] = params[:ratings]
      @movies = @movies.find_all{ |m| params[:ratings].key?(m.rating) }
    elsif(session.has_key?(:ratings) )
      params[:ratings] = session[:ratings]
      @redirect = true
    end

    if (@redirect)
      redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    end

    @checked = {}
    @all_ratings = ['G','PG','PG-13','R']

    @all_ratings.each { |rating|
      if params[:ratings] == nil
        @checked[rating] = true
      else
        @checked[rating] = params[:ratings].key?(rating)
      end
    }

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

end
