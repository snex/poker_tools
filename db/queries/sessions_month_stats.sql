-- Session results by day of week

\! echo ""
\! echo "========================================================================"
\! echo "Results and WRs by month"
\! echo "========================================================================"
\! echo ""

select
  case
    when date_part('month', start_time) = 1 then '01 - January'
    when date_part('month', start_time) = 2 then '02 - February'
    when date_part('month', start_time) = 3 then '03 - March'
    when date_part('month', start_time) = 4 then '04 - April'
    when date_part('month', start_time) = 5 then '05 - May'
    when date_part('month', start_time) = 6 then '06 - June'
    when date_part('month', start_time) = 7 then '07 - July'
    when date_part('month', start_time) = 8 then '08 - August'
    when date_part('month', start_time) = 9 then '09 - September'
    when date_part('month', start_time) = 10 then '10 - October'
    when date_part('month', start_time) = 11 then '11 - November'
    when date_part('month', start_time) = 12 then '12 - December'
    else ''
  end as month,
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
\! echo "End Results and WRs by month"
\! echo "========================================================================"
\! echo ""
