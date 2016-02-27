class Record
  def initialize(array)
    @record = {'user'=> array[0].to_i,'movie' => array[1].to_i, 'rating' => array[2].to_i}
  end

  def user
    return @record['user']
  end

  def movie
    return @record['movie']
  end

  def rating
    return @record['rating']
  end

end

class MovieData
  def load_data(filename)
    #load everything into records[], each element as a Record object
    #puts File.exist?(filename)
    if !filename.empty?
      data = File.open(filename)
      huge_array = data.read.split("\n")
      @records = []
      huge_array.each do |line|
        @records.push(Record.new(line.split("\t")))
      end
    end
    return @records
  end

  def initialize(args)
    #puts args.class
    ##args = arg.split(" ")
    #puts args[1]

    if args.size != 1 && args.size != 2
      puts "input error!"
    else
      #should we assume there'll always be a file named "u.data" in the given folder???
      if args.size == 1
        @TRAINING_SET  = Dir.pwd + "/" + args[0].to_s.chomp + "/u.data"
        @TEST_SET = String.new
        puts @TRAINING_SET
        puts File.exist?(@TRAINING_SET)

      else
        temp = Dir.pwd + "/" + args[0].to_s.chomp + "/" + args[1].to_s.chomp
        @TRAINING_SET =  temp + ".base"
        @TEST_SET = temp + ".test"
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
    if self.rating(user, movie) ==0
      temp = 0
      viewer_list = self.viewers(movie)
      viewer_list.each do |viewer|
        #puts self.rating(viewer, movie)
        temp += self.rating(viewer, movie)
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
  #Anyway to improve???
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
    if !@TEST_SET.empty?
      if k.empty?
        n = @test_set.size
      else
        n = k[0].to_i
      end
      result = MovieTest.new
      puts result.class
      (0...n-1).each do |i|
        result.push(@test_set.fetch(i).user, @test_set.fetch(i).movie, @test_set.fetch(i).rating, self.predict(@test_set.fetch(i).user, @test_set.fetch(i).movie))
      end
      return result
    else
      puts "no test set!!!"
    end
  end

end

class MovieTest



  def push(user, movie, rating, predicted_rating)
    @list = Array.new
    puts @list.class
    @list.push({'use'=> user, 'movie'=> movie, 'rating'=> rating, 'predicted_rating'=> predicted_rating})

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
    Math.sqrt((self.stddev ** 2) / @list.size)
  end

  def to_a
    returning_array = []
    @list.each do |t|
      returning_array.push = [t['user'], t['movie'], t['rating'], t['predicted_rating']]
    end
  end

end


INPUT = ARGV

movie_data = MovieData.new(INPUT)
puts movie_data.run_test().rms
