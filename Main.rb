require 'Record'
require 'MovieTest'
require 'MovieData'

INPUT = ARGV
movie_data = MovieData.new(INPUT)
puts movie_data.run_test("u1").rms
