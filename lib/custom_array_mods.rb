# frozen_string_literal: true

module CustomArrayMods
  def average
    sum / count.to_f
  end

  def cum_sum
    sum = 0
    map { |x| sum += x }
  end

  def longest_streak(comparator, operator)
    tmp_res = res = 0

    each do |r|
      if r.send(operator, comparator)
        tmp_res += 1
      else
        tmp_res = 0
      end

      res = tmp_res if tmp_res > res
    end

    res
  end

  def to_custom_sql_order(col)
    ret = +'CASE'
    each_with_index do |item, i|
      ret << " WHEN #{col} = '#{item}' THEN #{i}"
    end
    ret << ' END'

    Arel.sql(ret)
  end
end

class Array
  include CustomArrayMods
end
