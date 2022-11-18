# frozen_string_literal: true

class GameType
  class UnknownGameTypeException < StandardError; end

  attr_reader :bet_structure, :poker_variant, :stake

  def initialize(game_type_name)
    stake_name, game_name = game_type_name.split
    @stake = Stake.find_or_create_by(stake: stake_name)

    case game_name.try(:downcase)
    when 'nl'
      @bet_structure = BetStructure.find_by(name: 'No Limit')
      @poker_variant = PokerVariant.find_by(name: 'Texas Holdem')
    when 'bigo'
      @bet_structure = BetStructure.find_by(name: 'Pot Limit')
      @poker_variant = PokerVariant.find_by(name: 'BigO')
    when 'plo'
      @bet_structure = BetStructure.find_by(name: 'Pot Limit')
      @poker_variant = PokerVariant.find_by(name: 'Omaha')
    when 'pldbomb'
      @bet_structure = BetStructure.find_by(name: 'Pot Limit')
      @poker_variant = PokerVariant.find_by(name: 'Double Board Bomb Pots')
    else
      raise UnknownGameTypeException, "Unknown Game Type: #{game_name}"
    end
  end
end
