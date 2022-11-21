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
end
