class Array
  def cum_sum
    sum = 0
    self.map { |x| sum += x }
  end
end
