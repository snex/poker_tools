
\! echo ""
\! echo "========================================================================"
\! echo "Pots Won/Lost 80+bbs Stats"
\! echo "========================================================================"
\! echo ""

select
  num_hands
  ,round(pos::numeric / num_hands::numeric, 3) as win_rate
  ,round(won_per_hand, 2) as won_per_hand
from (
  select
    count(hand_histories.id) as num_hands
    ,sum(case when (result / stakes.stakes_array[1] >= 80) then 1 else 0 end) as pos
    ,sum(case when (result / stakes.stakes_array[1] <= -80) then 1 else 0 end) as neg
    ,avg(result) as won_per_hand
  from
    hand_histories
    inner join poker_sessions on hand_histories.poker_session_id = poker_sessions.id
    inner join game_types on poker_sessions.game_type_id = game_types.id
    inner join stakes on game_types.stake_id = stakes.id
  where
    (abs(result) / stakes.stakes_array[1]) >= 80
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
    ,sum(case when (result / stakes.stakes_array[1] >= 80) then 1 else 0 end) as pos
    ,sum(case when (result / stakes.stakes_array[1] <= -80) then 1 else 0 end) as neg
    ,avg(result) as won_per_hand
  from
    hand_histories
    inner join poker_sessions on hand_histories.poker_session_id = poker_sessions.id
    inner join game_types on poker_sessions.game_type_id = game_types.id
    inner join stakes on game_types.stake_id = stakes.id
  where
    (abs(result) / stakes.stakes_array[1]) >= 80
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
    ,sum(case when (result / stakes.stakes_array[1] >= 80) then 1 else 0 end) as pos
    ,sum(case when (result / stakes.stakes_array[1] <= -80) then 1 else 0 end) as neg
    ,avg(result) as won_per_hand
  from
    hand_histories
    inner join poker_sessions on hand_histories.poker_session_id = poker_sessions.id
    inner join game_types on poker_sessions.game_type_id = game_types.id
    inner join stakes on game_types.stake_id = stakes.id
  where
    (abs(result) / stakes.stakes_array[1]) >= 80
  group by 1
) as foo
order by 1 desc;

\! echo ""
\! echo "========================================================================"
\! echo "End Pots Won/Lost 80+bbs Stats"
\! echo "========================================================================"
\! echo ""
