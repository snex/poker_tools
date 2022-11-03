-- monthly and yearly stats for multi-way aipf pots

\! echo ""
\! echo "========================================================================"
\! echo "Multi-way All In Preflop Stats"
\! echo "========================================================================"
\! echo ""

select
  num_hands
  ,round(pos::numeric / num_hands::numeric, 3) as win_rate
  ,round(won_per_hand, 2) as won_per_hand
from (
  select
    count(hand_histories.id) as num_hands
    ,sum(case when (result / stakes.stakes_array[1] >= 0) then 1 else 0 end) as pos
    ,sum(case when (result / stakes.stakes_array[1] < 0) then 1 else 0 end) as neg
    ,avg(result) as won_per_hand
  from
    hand_histories
    inner join poker_sessions on hand_histories.poker_session_id = poker_sessions.id
    inner join stakes on poker_sessions.stake_id = stakes.id
  where
    all_in = true
    and showdown = true
    and flop is null
    and (
      note ilike '%side pot%'
      or note ilike '%vs muck%'
    )
  ) as foo
order by 1 desc;

select
  date as year
  ,num_hands
  ,round(pos::numeric / num_hands::numeric, 3) as win_rate
  ,round(won_per_hand, 2) as won_per_hand
from (
  select
    extract(year from poker_sessions.start_time) as date
    ,count(hand_histories.id) as num_hands
    ,sum(case when (result / stakes.stakes_array[1] >= 0) then 1 else 0 end) as pos
    ,sum(case when (result / stakes.stakes_array[1] < 0) then 1 else 0 end) as neg
    ,avg(result) as won_per_hand
  from
    hand_histories
    inner join poker_sessions on hand_histories.poker_session_id = poker_sessions.id
    inner join stakes on poker_sessions.stake_id = stakes.id
  where
    all_in = true
    and flop is null
    and showdown = true
    and (
      note ilike '%side pot%'
      or note ilike '%vs muck%'
    )
  group by 1
  ) as foo
order by 1 desc;

select
  date as month
  ,num_hands
  ,round(pos::numeric / num_hands::numeric, 3) as win_rate
  ,round(won_per_hand, 2) as won_per_hand
from (
  select
    extract(year from poker_sessions.start_time) || '-' || lpad(extract(month from poker_sessions.start_time)::varchar, 2, '0') as date
    ,count(hand_histories.id) as num_hands
    ,sum(case when (result / stakes.stakes_array[1] >= 0) then 1 else 0 end) as pos
    ,sum(case when (result / stakes.stakes_array[1] < 0) then 1 else 0 end) as neg
    ,avg(result) as won_per_hand
  from
    hand_histories
    inner join poker_sessions on hand_histories.poker_session_id = poker_sessions.id
    inner join stakes on poker_sessions.stake_id = stakes.id
  where
    all_in = true
    and flop is null
    and showdown = true
    and (
      note ilike '%side pot%'
      or note ilike '%vs muck%'
    )
  group by 1
) as foo
order by 1 desc;

\! echo ""
\! echo "========================================================================"
\! echo "End Multi-way All In Preflop Stats"
\! echo "========================================================================"
\! echo ""
