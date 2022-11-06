json.dates @poker_sessions.pluck(:start_time).map(&:to_date)
json.datapoints @poker_sessions.pluck(Arel.sql('cashout - buyin')).cum_sum
