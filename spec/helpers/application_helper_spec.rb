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

  describe '.hand_filter' do
    let(:aa) { Hand.find_by_hand('AA') }
    let(:kk) { Hand.find_by_hand('KK') }

    it 'returns a hand_filter select' do
      expect(hand_filter(Hand.where(id: [aa, kk]), aa.id)).to eq("<select name=\"hand[]\" id=\"hand-select\" class=\"form-control\" data-placeholder=\"Filter By Hand\" multiple=\"multiple\"><option value=\"\"></option>\n<option selected=\"selected\" value=\"#{aa.id}\">#{aa.hand}</option>\n<option value=\"#{kk.id}\">#{kk.hand}</option></select><button name=\"button\" type=\"button\" id=\"reset-hand\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end

  describe '.position_filter' do
    let(:sb) { Position.find_by_position('SB') }
    let(:bb) { Position.find_by_position('BB') }

    it 'returns a position_filter select' do
      expect(position_filter(Position.where(id: [sb, bb]), bb.id)).to eq("<select name=\"position[]\" id=\"position-select\" class=\"form-control\" data-placeholder=\"Filter By Position\" multiple=\"multiple\"><option value=\"\"></option>\n<option value=\"#{sb.id}\">#{sb.position}</option>\n<option selected=\"selected\" value=\"#{bb.id}\">#{bb.position}</option></select><button name=\"button\" type=\"button\" id=\"reset-position\" class=\"form-control form-control-sm filter-button\">x</button>")
    end
  end
end
