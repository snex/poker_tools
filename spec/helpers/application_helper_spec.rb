# frozen_string_literal: true

require 'application_helper'

RSpec.describe ApplicationHelper do
  describe '.bg_color_by_result' do
    context 'negative' do
      it "returns 'alert alert-danger'" do
        expect(bg_color_by_result(-1)).to eq('alert alert-danger')
      end
    end

    context 'positive' do
      it "returns 'alert alert-success'" do
        expect(bg_color_by_result(1)).to eq('alert alert-success')
      end
    end

    context 'zero' do
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

      expect(bet_size_filter('')).to eq("<select name=\"bet_size[]\" id=\"bet-size-select\" class=\"form-control\" data-placeholder=\"Filter By Bet Size\" multiple=\"multiple\"><option selected=\"selected\" value=\"\"></option>\n#{options}</select><button name=\"button\" type=\"button\" id=\"reset-bet-size\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end

  describe '.date_filter' do
    let(:from) { (Date.today - 1.day).to_s }
    let(:to) { Date.today.to_s }

    it 'returns a pair of date_filter text boxes' do
      expect(date_filter(from, to)).to eq("<input type=\"text\" name=\"from\" id=\"from-filter\" value=\"#{from}\" class=\"form-control form-control-sm\" placeholder=\"From\" /><button name=\"button\" type=\"button\" id=\"reset-from\" class=\"form-control form-control-sm filter-button\">x</button><input type=\"text\" name=\"to\" id=\"to-filter\" value=\"#{to}\" class=\"form-control form-control-sm\" placeholder=\"To\" /><button name=\"button\" type=\"button\" id=\"reset-to\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end

  describe '.hand_filter' do
    it 'returns a hand_filter select' do
      options = Hand.cached.map do |id, hand|
        "<option value=\"#{id}\">#{hand}</option>"
      end.join("\n")

      expect(hand_filter('')).to eq("<select name=\"hand[]\" id=\"hand-select\" class=\"form-control\" data-placeholder=\"Filter By Hand\" multiple=\"multiple\"><option selected=\"selected\" value=\"\"></option>\n#{options}</select><button name=\"button\" type=\"button\" id=\"reset-hand\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end

  describe '.position_filter' do
    it 'returns a position_filter select' do
      options = Position.cached.map do |id, position|
        "<option value=\"#{id}\">#{position}</option>"
      end.join("\n")

      expect(position_filter('')).to eq("<select name=\"position[]\" id=\"position-select\" class=\"form-control\" data-placeholder=\"Filter By Position\" multiple=\"multiple\"><option selected=\"selected\" value=\"\"></option>\n#{options}</select><button name=\"button\" type=\"button\" id=\"reset-position\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end

  describe '.stake_filter' do
    before { create :stake }

    it 'returns a stake_filter select' do
      options = Stake.cached.map do |id, stake|
        "<option value=\"#{id}\">#{stake}</option>"
      end.join("\n")

      expect(stake_filter('')).to eq("<select name=\"stake[]\" id=\"stake-select\" class=\"form-control\" data-placeholder=\"Filter By Stake\" multiple=\"multiple\"><option selected=\"selected\" value=\"\"></option>\n#{options}</select><button name=\"button\" type=\"button\" id=\"reset-stake\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end

  describe '.table_size_filter' do
    it 'returns a table_size_filter select' do
      options = TableSize.cached.map do |id, stake|
        "<option value=\"#{id}\">#{stake}</option>"
      end.join("\n")

      expect(table_size_filter('')).to eq("<select name=\"table_size[]\" id=\"table-size-select\" class=\"form-control\" data-placeholder=\"Filter By Table Size\" multiple=\"multiple\"><option selected=\"selected\" value=\"\"></option>\n#{options}</select><button name=\"button\" type=\"button\" id=\"reset-table-size\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end

  describe '.advanced_filters' do
    it 'returns a select filter for flop, turn, river, showdown, and all-in' do
      expect(advanced_filters(nil, nil, nil, nil, nil)).to eq("<select name=\"flop\" id=\"flop-select\" class=\"form-control\" data-placeholder=\"Saw Flop?\"><option value=\"\"></option>\n<option value=\"true\">true</option>\n<option value=\"false\">false</option></select><button name=\"button\" type=\"button\" id=\"reset-flop\" class=\"form-control form-control-sm filter-button\">x</button><select name=\"turn\" id=\"turn-select\" class=\"form-control\" data-placeholder=\"Saw Turn?\"><option value=\"\"></option>\n<option value=\"true\">true</option>\n<option value=\"false\">false</option></select><button name=\"button\" type=\"button\" id=\"reset-turn\" class=\"form-control form-control-sm filter-button\">x</button><select name=\"river\" id=\"river-select\" class=\"form-control\" data-placeholder=\"Saw River?\"><option value=\"\"></option>\n<option value=\"true\">true</option>\n<option value=\"false\">false</option></select><button name=\"button\" type=\"button\" id=\"reset-river\" class=\"form-control form-control-sm filter-button\">x</button><select name=\"showdown\" id=\"showdown-select\" class=\"form-control\" data-placeholder=\"Went To Showdown?\"><option value=\"\"></option>\n<option value=\"true\">true</option>\n<option value=\"false\">false</option></select><button name=\"button\" type=\"button\" id=\"reset-showdown\" class=\"form-control form-control-sm filter-button\">x</button><select name=\"all_in\" id=\"all-in-select\" class=\"form-control\" data-placeholder=\"All In?\"><option value=\"\"></option>\n<option value=\"true\">true</option>\n<option value=\"false\">false</option></select><button name=\"button\" type=\"button\" id=\"reset-all-in\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end
end
