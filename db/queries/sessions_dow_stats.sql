-- Session results by day of week

\! echo ""
\! echo "========================================================================"
\! echo "Results and WRs by day of week"
\! echo "========================================================================"
\! echo ""

select
  case
    when date_part('dow', start_time) = 0 then '1 - Sunday'
    when date_part('dow', start_time) = 1 then '2 - Monday'
    when date_part('dow', start_time) = 2 then '3 - Tuesday'
    when date_part('dow', start_time) = 3 then '4 - Wednesday'
    when date_part('dow', start_time) = 4 then '5 - Thursday'
    when date_part('dow', start_time) = 5 then '6 - Friday'
    when date_part('dow', start_time) = 6 then '7 - Saturday'
    else ''
  end,
  sum(cashout - buyin) as result,
  lpad(cast(sum(end_time - start_time) as varchar), 11)  as hours,
  round(cast(sum(cashout - buyin) / extract(epoch from sum(end_time - start_time)/ 3600) as numeric), 2) as hourly
from
  poker_sessions
  inner join game_types on poker_sessions.game_type_id = game_types.id
  inner join poker_variants on poker_variants.id = game_types.poker_variant_id
where
  poker_variants.name = 'Texas Holdem'
group by 1
order by 1;

\! echo ""
\! echo "========================================================================"
\! echo "End Results and WRs by day of week"
\! echo "========================================================================"
\! echo ""
