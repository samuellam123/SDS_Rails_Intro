class MoviesController < ApplicationController
  
  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def index
    @all_ratings = Movie.all_ratings

    session[:ratings] = params[:ratings] if params[:ratings]
    session[:sort_by] = params[:sort_by] if params[:sort_by]

    @ratings_to_show = params[:ratings] ? params[:ratings].keys : session[:ratings] ? session[:ratings].keys : @all_ratings
    @ratings_to_show_hash = Hash[@ratings_to_show.map { |rating| [rating, 1] }]

    @sort_column = params[:sort_by] || session[:sort_by]
    session[:ratings] = @ratings_to_show_hash if params[:ratings]
    session[:sort_by] = @sort_column if params[:sort_by]
    
    @movies = Movie.with_ratings(@ratings_to_show)
    @movies = @movies.order(@sort_column) if @sort_column
  end

  def new
    render "new.html.erb"
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

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

end
