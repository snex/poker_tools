# frozen_string_literal: true

require 'application_helper'

RSpec.describe ApplicationHelper do
  describe '.bg_color_by_result' do
    context 'when result is negative' do
      it "returns 'alert alert-danger'" do
        expect(bg_color_by_result(-1)).to eq('alert alert-danger')
      end
    end

    context 'when result is positive' do
      it "returns 'alert alert-success'" do
        expect(bg_color_by_result(1)).to eq('alert alert-success')
      end
    end

    context 'when result is zero' do
      it "returns 'alert'" do
        expect(bg_color_by_result(0)).to eq('alert')
      end
    end
  end

  describe '.bet_size_filter' do
    it 'returns a bet_size_filter select' do
      options = BetSize.cached.map do |id, desc|
        "<option value=\"#{id}\">#{desc}</option>"
      end.join("\n")

      expect(bet_size_filter(''))
        .to eq(ERB.new(file_fixture('filter_helpers/bet_size_filter.html.erb').read.strip).result(binding))
    end
  end

  describe '.date_filter' do
    let(:from) { (Time.zone.today - 1.day).to_s }
    let(:to) { Time.zone.today.to_s }

    it 'returns a pair of date_filter text boxes' do
      expect(date_filter(from, to))
        .to eq(ERB.new(file_fixture('filter_helpers/date_filter.html.erb').read.strip).result(binding))
    end
  end

  describe '.hand_filter' do
    it 'returns a hand_filter select' do
      options = Hand.cached.map do |id, hand|
        "<option value=\"#{id}\">#{hand}</option>"
      end.join("\n")

      expect(hand_filter(''))
        .to eq(ERB.new(file_fixture('filter_helpers/hand_filter.html.erb').read.strip).result(binding))
    end
  end

  describe '.position_filter' do
    it 'returns a position_filter select' do
      options = Position.cached.map do |id, position|
        "<option value=\"#{id}\">#{position}</option>"
      end.join("\n")

      expect(position_filter(''))
        .to eq(ERB.new(file_fixture('filter_helpers/position_filter.html.erb').read.strip).result(binding))
    end
  end

  describe '.stake_filter' do
    before { create(:stake) }

    it 'returns a stake_filter select' do
      options = Stake.cached.map do |id, stake|
        "<option value=\"#{id}\">#{stake}</option>"
      end.join("\n")

      expect(stake_filter(''))
        .to eq(ERB.new(file_fixture('filter_helpers/stake_filter.html.erb').read.strip).result(binding))
    end
  end

  describe '.table_size_filter' do
    it 'returns a table_size_filter select' do
      options = TableSize.cached.map do |id, stake|
        "<option value=\"#{id}\">#{stake}</option>"
      end.join("\n")

      expect(table_size_filter(''))
        .to eq(ERB.new(file_fixture('filter_helpers/table_size_filter.html.erb').read.strip).result(binding))
    end
  end

  describe '.advanced_filters' do
    it 'returns a select filter for flop, turn, river, showdown, and all-in' do
      expect(advanced_filters(nil, nil, nil, nil, nil))
        .to eq(file_fixture('filter_helpers/advanced_filters.html').read.strip)
    end
  end
end
