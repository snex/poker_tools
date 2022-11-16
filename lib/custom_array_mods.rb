module CustomArrayMods
  def average
    self.sum.to_f / self.count.to_f
  end

  def cum_sum
    sum = 0
    self.map { |x| sum += x }
  end

  def longest_streak(comparator, operator)
    tmp_res = res = 0
    self.each do |r|
      if r.send(operator, comparator)
        tmp_res += 1
      else
        tmp_res = 0
      end
      if tmp_res > res
        res = tmp_res
      end
    end
    res
  end

  def to_custom_sql_order(col)
    ret = 'CASE'
    self.each_with_index do |item, i|
      ret << " WHEN #{col} = '#{item}' THEN #{i}"
    end
    ret << ' END'

    Arel.sql(ret)
  end
end

class Array
  include CustomArrayMods
end
