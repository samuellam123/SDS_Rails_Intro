class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    # If ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    # movies with those ratings
    # If ratings_list is nil or empty, retrieve ALL movies
    if ratings_list.blank?  # This checks for both nil and empty
      return Movie.all
    else
      return Movie.where(rating: ratings_list)
    end
  end

  def self.all_ratings
    Movie.select(:rating).distinct.pluck(:rating)
  end
end
