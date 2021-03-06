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
    sort_category=params[:sort_by]
    
    # @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @movies = Movie.all
    @selectedRatings = @all_ratings
    
    if (!params[:ratings].nil?) 
      
      arr = []
      params[:ratings].each {|key, value| arr.push(key) }
      
      @movies = Movie.where(rating: arr)
      @selectedRatings = arr
    end
    
    if !(params[:sort_by].nil?)
    @movies=Movie.all.order(sort_category)
      if params[:sort_by]=='title'
        @title_tohilite='hilite'
      elsif params[:sort_by]=='release_date'
        @release_tohilite='hilite'
      end
    end
  end

  def upd
    # 
  end
  
  def real_upd
    title = params[:movie][:title]
    dbMovie = Movie.find_by_title(title)
    
    if dbMovie.nil?
      flash[:notice] = "Movies #{title} doens't exists"
    else
      if !(params[:movie][:newtitle] == "" || params[:movie][:rating] == " ")
      myDate =  Date.new params[:movie]["release_date(1i)"].to_i, params[:movie]["release_date(2i)"].to_i, params[:movie]["release_date(3i)"].to_i
      dbMovie.update_attribute(:title,params[:movie][:newtitle])
      dbMovie.update_attribute(:rating,params[:movie][:rating])
      dbMovie.update_attribute(:release_date,myDate)
    else
      flash[:notice] = "Movies #{title} cannot updaate feilds blank"
      # dat = Date.new params[:movie]["release_date(1i)"].to_i, params[:movie]["release_date(2i)"].to_i, params[:movie]["release_date(3i)"].to_i
      #check = Date.new params[movie]["release_date(1i)"].to_i, params[movie]["release_date(2i)"].to_i, params[movie]["release_date(3i)"].to_i
    end
    end

    redirect_to movies_path
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
  
  def del
  end

  def my_delete
    if params[:movie][:title] == " " && params[:movie][:rating]
      flash[:notice] = " feilds cannot be empty."
    else
    
    t  =  params[:movie][:title]
    m = Movie.find_by_title( params[:movie][:title])
    
    if (not (m.nil? or t == ""))
      m.destroy
    end
    r = params[:movie][:rating]
    
    m = Movie.find_by_rating(params[:movie][:rating])
    
    while(not(r == " " or m.nil?))
      m.destroy
      m = Movie.find_by_rating(r)
    end
    flash[:notice] = " movie deleted."
    redirect_to movies_path
  end
  end



  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
