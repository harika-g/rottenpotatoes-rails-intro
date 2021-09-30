class Movie < ActiveRecord::Base
    def self.all_ratings
        select(:rating).map(&:rating).uniq
    end
    def self.with_ratings(ratings_list)
        if(ratings_list && ratings_list.length)
            where(rating: ratings_list)
        else 
            all
        end
    end
end
