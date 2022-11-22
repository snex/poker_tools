require 'seed_box'
include SeedBox

seed BetSize, {
  bet_size:    1,
  description: 'limp',
  color:       'red'
}
seed BetSize, {
  bet_size:    2,
  description: '2b',
  color:       'orange'
}
seed BetSize, {
  bet_size:    3,
  description: '3b',
  color:       'yellow'
}
seed BetSize, {
  bet_size:    4,
  description: '4b',
  color:       'green'
}
seed BetSize, {
  bet_size:    5,
  description: '5b',
  color:       'blue'
}
seed BetSize, {
  bet_size:    6,
  description: '6b',
  color:       'purple'
}


seed BetStructure, {
  name:         'No Limit',
  abbreviation: 'NL',
}
seed BetStructure, {
  name:         'Pot Limit',
  abbreviation: 'PL',
}
seed BetStructure, {
  name:         'Fixed Limit',
  abbreviation: 'FL',
}


seed Hand, { hand: 'AA' }
seed Hand, { hand: 'KK' }
seed Hand, { hand: 'QQ' }
seed Hand, { hand: 'JJ' }
seed Hand, { hand: 'TT' }
seed Hand, { hand: '99' }
seed Hand, { hand: '88' }
seed Hand, { hand: '77' }
seed Hand, { hand: '66' }
seed Hand, { hand: '55' }
seed Hand, { hand: '44' }
seed Hand, { hand: '33' }
seed Hand, { hand: '22' }
seed Hand, { hand: 'AKs' }
seed Hand, { hand: 'AQs' }
seed Hand, { hand: 'AJs' }
seed Hand, { hand: 'ATs' }
seed Hand, { hand: 'A9s' }
seed Hand, { hand: 'A8s' }
seed Hand, { hand: 'A7s' }
seed Hand, { hand: 'A6s' }
seed Hand, { hand: 'A5s' }
seed Hand, { hand: 'A4s' }
seed Hand, { hand: 'A3s' }
seed Hand, { hand: 'A2s' }
seed Hand, { hand: 'KQs' }
seed Hand, { hand: 'KJs' }
seed Hand, { hand: 'KTs' }
seed Hand, { hand: 'K9s' }
seed Hand, { hand: 'K8s' }
seed Hand, { hand: 'K7s' }
seed Hand, { hand: 'K6s' }
seed Hand, { hand: 'K5s' }
seed Hand, { hand: 'K4s' }
seed Hand, { hand: 'K3s' }
seed Hand, { hand: 'K2s' }
seed Hand, { hand: 'QJs' }
seed Hand, { hand: 'QTs' }
seed Hand, { hand: 'Q9s' }
seed Hand, { hand: 'Q8s' }
seed Hand, { hand: 'Q7s' }
seed Hand, { hand: 'Q6s' }
seed Hand, { hand: 'Q5s' }
seed Hand, { hand: 'Q4s' }
seed Hand, { hand: 'Q3s' }
seed Hand, { hand: 'Q2s' }
seed Hand, { hand: 'JTs' }
seed Hand, { hand: 'J9s' }
seed Hand, { hand: 'J8s' }
seed Hand, { hand: 'J7s' }
seed Hand, { hand: 'J6s' }
seed Hand, { hand: 'J5s' }
seed Hand, { hand: 'J4s' }
seed Hand, { hand: 'J3s' }
seed Hand, { hand: 'J2s' }
seed Hand, { hand: 'T9s' }
seed Hand, { hand: 'T8s' }
seed Hand, { hand: 'T7s' }
seed Hand, { hand: 'T6s' }
seed Hand, { hand: 'T5s' }
seed Hand, { hand: 'T4s' }
seed Hand, { hand: 'T3s' }
seed Hand, { hand: 'T2s' }
seed Hand, { hand: '98s' }
seed Hand, { hand: '97s' }
seed Hand, { hand: '96s' }
seed Hand, { hand: '95s' }
seed Hand, { hand: '94s' }
seed Hand, { hand: '93s' }
seed Hand, { hand: '92s' }
seed Hand, { hand: '87s' }
seed Hand, { hand: '86s' }
seed Hand, { hand: '85s' }
seed Hand, { hand: '84s' }
seed Hand, { hand: '83s' }
seed Hand, { hand: '82s' }
seed Hand, { hand: '76s' }
seed Hand, { hand: '75s' }
seed Hand, { hand: '74s' }
seed Hand, { hand: '73s' }
seed Hand, { hand: '72s' }
seed Hand, { hand: '65s' }
seed Hand, { hand: '64s' }
seed Hand, { hand: '63s' }
seed Hand, { hand: '62s' }
seed Hand, { hand: '54s' }
seed Hand, { hand: '53s' }
seed Hand, { hand: '52s' }
seed Hand, { hand: '43s' }
seed Hand, { hand: '42s' }
seed Hand, { hand: '32s' }
seed Hand, { hand: 'AKo' }
seed Hand, { hand: 'AQo' }
seed Hand, { hand: 'AJo' }
seed Hand, { hand: 'ATo' }
seed Hand, { hand: 'A9o' }
seed Hand, { hand: 'A8o' }
seed Hand, { hand: 'A7o' }
seed Hand, { hand: 'A6o' }
seed Hand, { hand: 'A5o' }
seed Hand, { hand: 'A4o' }
seed Hand, { hand: 'A3o' }
seed Hand, { hand: 'A2o' }
seed Hand, { hand: 'KQo' }
seed Hand, { hand: 'KJo' }
seed Hand, { hand: 'KTo' }
seed Hand, { hand: 'K9o' }
seed Hand, { hand: 'K8o' }
seed Hand, { hand: 'K7o' }
seed Hand, { hand: 'K6o' }
seed Hand, { hand: 'K5o' }
seed Hand, { hand: 'K4o' }
seed Hand, { hand: 'K3o' }
seed Hand, { hand: 'K2o' }
seed Hand, { hand: 'QJo' }
seed Hand, { hand: 'QTo' }
seed Hand, { hand: 'Q9o' }
seed Hand, { hand: 'Q8o' }
seed Hand, { hand: 'Q7o' }
seed Hand, { hand: 'Q6o' }
seed Hand, { hand: 'Q5o' }
seed Hand, { hand: 'Q4o' }
seed Hand, { hand: 'Q3o' }
seed Hand, { hand: 'Q2o' }
seed Hand, { hand: 'JTo' }
seed Hand, { hand: 'J9o' }
seed Hand, { hand: 'J8o' }
seed Hand, { hand: 'J7o' }
seed Hand, { hand: 'J6o' }
seed Hand, { hand: 'J5o' }
seed Hand, { hand: 'J4o' }
seed Hand, { hand: 'J3o' }
seed Hand, { hand: 'J2o' }
seed Hand, { hand: 'T9o' }
seed Hand, { hand: 'T8o' }
seed Hand, { hand: 'T7o' }
seed Hand, { hand: 'T6o' }
seed Hand, { hand: 'T5o' }
seed Hand, { hand: 'T4o' }
seed Hand, { hand: 'T3o' }
seed Hand, { hand: 'T2o' }
seed Hand, { hand: '98o' }
seed Hand, { hand: '97o' }
seed Hand, { hand: '96o' }
seed Hand, { hand: '95o' }
seed Hand, { hand: '94o' }
seed Hand, { hand: '93o' }
seed Hand, { hand: '92o' }
seed Hand, { hand: '87o' }
seed Hand, { hand: '86o' }
seed Hand, { hand: '85o' }
seed Hand, { hand: '84o' }
seed Hand, { hand: '83o' }
seed Hand, { hand: '82o' }
seed Hand, { hand: '76o' }
seed Hand, { hand: '75o' }
seed Hand, { hand: '74o' }
seed Hand, { hand: '73o' }
seed Hand, { hand: '72o' }
seed Hand, { hand: '65o' }
seed Hand, { hand: '64o' }
seed Hand, { hand: '63o' }
seed Hand, { hand: '62o' }
seed Hand, { hand: '54o' }
seed Hand, { hand: '53o' }
seed Hand, { hand: '52o' }
seed Hand, { hand: '43o' }
seed Hand, { hand: '42o' }
seed Hand, { hand: '32o' }

seed PokerVariant, {
  name:         'Texas Holdem',
  abbreviation: 'HE'
}
seed PokerVariant, {
  name:         'Omaha',
  abbreviation: 'O'
}
seed PokerVariant, {
  name:         'BigO',
  abbreviation: 'BigO'
}
seed PokerVariant, {
  name:         'Mix',
  abbreviation: 'Mix'
}
seed PokerVariant, {
  name:         'Omaha Hi-Lo',
  abbreviation: 'O8'
}
seed PokerVariant, {
  name:         'Double Board Bomb Pots',
  abbreviation: 'DBomb'
}

seed Position, {
  position: 'SB',
  color:    '#c10001'
}
seed Position, {
  position: 'BB',
  color:    '#ff8f00'
}
seed Position, {
  position: 'UTG',
  color:    '#edff5b'
}
seed Position, {
  position: 'UTG1',
  color:    '#edff5b'
}
seed Position, {
  position: 'UTG2',
  color:    'black'
}
seed Position, {
  position: 'MP',
  color:    '#1a9391'
}
seed Position, {
  position: 'LJ',
  color:    '#00c4da'
}
seed Position, {
  position: 'HJ',
  color:    '#610c8c'
}
seed Position, {
  position: 'CO',
  color:    '#d223fe'
}
seed Position, {
  position: 'BU',
  color:    '#b30347'
}
seed Position, {
  position: 'STRADDLE',
  color:    'black'
}

seed TableSize, {
  table_size:  9,
  description: '10/9/8 handed'
}
seed TableSize, {
  table_size:  7,
  description: '7 handed'
}
seed TableSize, {
  table_size:  6,
  description: '6 handed'
}
seed TableSize, {
  table_size:  5,
  description: '5 handed'
}
seed TableSize, {
  table_size:  4,
  description: '4 handed'
}
seed TableSize, {
  table_size:  3,
  description: '3 handed'
}
seed TableSize, {
  table_size:  2,
  description: 'Heads Up'
}
