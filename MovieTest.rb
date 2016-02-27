require 'MovieData'

class MovieTest

  def push(user, movie, rating, predicted_rating)
    @list.push({'use'=> user, 'movie'=> movie, 'rating'=> rating, 'predicted_rating'=> MovieData.predict(user, movie)})
  end

  def mean
    @list.each do |tuple|
      temp += tuple['rating'] - tuple['predicted_rating']
      #using average()??
    end
    return temp / @list.size
  end
#t.mean returns the average predication error (which should be close to zero)
#t.stddev returns the standard deviation of the error
#t.rms returns the root mean square error of the prediction
#t.to_a returns an array of the predictions in the form [u,m,r,p]. You can also generate other types of error measures if you want, but we will rely mostly on the root mean square error.
  def stddev
    mean  = self.mean
    @list.each do |tuple|
      temp += (tuple['rating'] - tuple['predicted_rating'] - mean) ** 2
    end
    Math.sqrt(temp)
  end

  def rms
    result = Math.sqrt((self.stddev ** 2) / @list.size)
  end

  def to_a
    returning_array = []
    @list.each do |t|
      returning_array.push = [t['user'], t['movie'], t['rating'], t['predicted_rating']]
    end
  end
end
