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
