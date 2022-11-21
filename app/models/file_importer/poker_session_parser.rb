# frozen_string_literal: true

class FileImporter
  class PokerSessionParser
    def initialize(date, data)
      @data = data
      @ps_attrs = {}

      parse_game_type
      parse_result
      parse_duration(date)
      parse_hands_dealt
    end

    def call
      PokerSession.create!(@ps_attrs)
    end

    private

    def parse_game_type
      gt = GameType.new(@data.match(/session (.+)/i)[1])
      @ps_attrs[:stake] = gt.stake
      @ps_attrs[:bet_structure] = gt.bet_structure
      @ps_attrs[:poker_variant] = gt.poker_variant
    end

    def parse_result
      @ps_attrs[:buyin] = @data.match(/^in: (.*)$/i)[1].to_i
      @ps_attrs[:cashout] = @data.match(/^out: (.*)$/i)[1].to_i
    end

    def parse_duration(date)
      start_str = "#{date} #{@data.match(/^start: (.*)$/i)[1]}"
      end_str = "#{date} #{@data.match(/^end: (.*)$/i)[1]}"
      @ps_attrs[:start_time] = Time.zone.parse(start_str)
      @ps_attrs[:end_time] = Time.zone.parse(end_str)

      # this can happen if the session goes beyond midnight
      @ps_attrs[:end_time] += 1.day if @ps_attrs[:end_time] < @ps_attrs[:start_time]
    end

    def parse_hands_dealt
      hands = @data.match(/^hands: (.*)$/i).try(:[], 1)
      @ps_attrs[:hands_dealt] = hands.to_i if hands
    end
  end
end
