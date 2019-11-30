json.ids (1..@raw_numbers.size).to_a
json.datapoints @raw_numbers.cum_sum
json.bet_size_colors @hand_histories.map { |hh| hh.bet_size.color }
json.position_colors @hand_histories.map { |hh| hh.position.color }
json.results @hand_histories.pluck(:result)
json.dates @hand_histories.pluck(:date)
json.notes @hand_histories.pluck(:note)
json.hand_count @hand_histories.count
json.hand_sum @raw_numbers.sum.to_i
json.hand_pct (100 * @raw_numbers.select { |num| num > 0 }.count.to_f / @hand_histories.count.to_f).round(2)
json.hand_avg @raw_numbers.mean.to_f.round(2)
json.hand_stddev @raw_numbers.standard_deviation.to_f.round(2)
