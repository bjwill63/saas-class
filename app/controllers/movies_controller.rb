class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']

if params[:ratings] != nil
	@vRatings = params[:ratings]
elsif session[:ratings] != nil
	@vRatings = {} #session[:ratings]
else
        @vRatings = {}	
end

    if (params[:commit] != nil) 
       if @vRatings == {}
          #@movies = Movie.all
	  #@parms = {:ratings=>{"G"=>"G","PG"=>"PG","PG-13"=>"PG-13","R"=>"R"}}
          @movies =  Movie.where("rating IN (?)", "")
       else	
          @movies =  Movie.where("rating IN (?)", @vRatings.keys)
       end
    elsif @vRatings == {}
          @movies = Movie.all
          @vRatings = {"G"=>"G","PG"=>"PG","PG-13"=>"PG-13","R"=>"R"}
    else	
	  @movies =  Movie.where("rating IN (?)", @vRatings.keys)
    end	       	
    session[:ratings] = @vRatings	
 #session[:ratings] = nil
    @sort = params[:sort]
    if @sort == "desc"
       @movies.sort! { |a,b| b.title.downcase <=> a.title.downcase }
       @sort = "asc"
       @title_header='hilite'	
    elsif @sort == "asc"	 
       @movies.sort! { |a,b| a.title.downcase <=> b.title.downcase }
       @sort = "desc"
       @title_header='hilite'
    else
       @sort = "asc"
    end

    @sort_rel = params[:sort_rel]
    if @sort_rel == "desc"
       @movies = @movies.sort_by {|e| e.release_date}.reverse
       @sort_rel = "asc"	
       @release_header='hilite'
    elsif @sort_rel == "asc"	 
       @movies.sort_by! {|e| e.release_date}
       @sort_rel = "desc" 	
       @release_header='hilite'
    else
       @sort_rel = "asc"
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
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
