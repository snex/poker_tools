# frozen_string_literal: true

class GameType
  class UnknownGameTypeException < StandardError ; end

  attr_reader :bet_structure, :poker_variant, :stake

  def initialize(game_type_name)
    stake_name, game_name = game_type_name.split(' ')
    @stake = Stake.find_or_create_by(stake: stake_name)

    case game_name.try(:downcase)
    when 'nl'
      @bet_structure = BetStructure.find_by_name('No Limit')
      @poker_variant = PokerVariant.find_by_name('Texas Holdem')
    when 'bigo'
      @bet_structure = BetStructure.find_by_name('Pot Limit')
      @poker_variant = PokerVariant.find_by_name('BigO')
    when 'plo'
      @bet_structure = BetStructure.find_by_name('Pot Limit')
      @poker_variant = PokerVariant.find_by_name('Omaha')
    when 'pldbomb'
      @bet_structure = BetStructure.find_by_name('Pot Limit')
      @poker_variant = PokerVariant.find_by_name('Double Board Bomb Pots')
    else
      raise UnknownGameTypeException.new("Unknown Game Type: #{game_name}")
    end
  end
end
