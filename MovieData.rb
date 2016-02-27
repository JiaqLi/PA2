require 'Record'

class MovieData
  def load_data(filename)
    #load everything into records[], each element as a Record object
    data = open(filename)
    huge_array = data.read.split("\n")
    @records = []
    huge_array.each do |line|
      @records.push(Record.new(line.split("\t")))
    end
    return @records
  end

  def initialize(*args)
    if args.size != 1 && args.size != 2
      puts "input error!"
    else
      #should we assume there'll always be a file named "u.data" in the given folder???
      if args.size == 1
        @TRAINING_SET  = args[0].chomp.to_s + "/u.data"
        @TEST_SET = nil
      else
        @TRAINING_SET = args[0].chomp.to_s + "/" + args[1].chomp.to_s + ".base"
        @TEST_SET = args[1].chomp.to_s + ".test"
      end
      @training_set = self.load_data(@TRAINING_SET)
      @test_set = self.load_data(@TEST_SET)
    end
  end

  def rating(user, movie)
    r = 0
    @training_set.each do |record|
      if record.user == user.to_i && record.movie == movie.to_i
        r = record.rating
      end
    end
    return r
  end

  def predict(user, movie)
    #better algo??
    if self.rating(user.movie) ==0
      viewer_list = self.viewers(movie)
      viewer_list.each do |viewer|
        temp += rating(viewer, movie)
      end
      return temp / viewer_list.size
    else
      return self.rating(user, movie)
    end
  end
#  z.rating(u,m) returns the rating that user u gave movie m in the training set, and 0 if user u did not rate movie m
#  z.predict(u,m) returns a floating point number between 1.0 and 5.0 as an estimate of what user u would rate movie m
#  z.movies(u) returns the array of movies that user u has watched
#  z.viewers(m) returns the array of users that have seen movie m
#  z.run_test(k) runs the z.predict method on the first k ratings in the test set and returns a MovieTest object containing the results.
#
#      The parameter k is optional and if omitted, all of the tests will be run.
#
#
  def movies(user)
    movies_he_watched = []
    @training_set.each do |record|
      if record.user == user.to_i
        movies_he_watched.push(record.movie)
      end
    end
    return movies_he_watched
  end

  def viewers(movie)
    people_watched_this = []
    @training_set.each do |record|
      if record.movie == movie.to_i
        people_watched_this.push(record.user)
      end
    end
    return people_watched_this
  end

  def run_test(*k)
    if k.empty?
      n = @test_set.size
    else
      n = k.to_i
    end
    result = MovieTest.new
    @test_set.each do |record|
      result.push(record.user, record.movie, record.rating, self.predict(record.user, record.movie))
    return result
  end

end
