FactoryBot.define do
  factory :hand_history do
    date       { Date.today }
    result     { rand(-500..500) }
    hand       { Hand.order('random()').first }
    position   { Position.order('random()').first }
    bet_size   { BetSize.order('random()').first }
    table_size { TableSize.order('random()').first }
    note       { "Utg open 8, MP call, call Co 22\nFlop A82dd, x x b 15, c c\nTurn 6s bdfd, x x b 55, c f\nRiver Td, x b 100, c\nV muck" }
  end
end
