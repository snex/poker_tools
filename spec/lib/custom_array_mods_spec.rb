# frozen_string_literal: true

RSpec.describe CustomArrayMods do
  describe '#average' do
    subject { [1, 2].average }

    it { is_expected.to eq(1.5) }
  end

  describe '#cum_sum' do
    subject { [1, 2, 3, 4].cum_sum }

    it { is_expected.to eq([1, 3, 6, 10]) }
  end

  describe '#longest_streak' do
    context 'when == is the operator' do
      subject { [1, 2, 2, 3].longest_streak(2, :==) }

      it { is_expected.to eq(2) }
    end

    context 'when > is the operator' do
      subject { [1, 2, 3, -1, 4, 5].longest_streak(0, :>) }

      it { is_expected.to eq(3) }
    end
  end

  describe '#to_custom_sql_order' do
    subject { %w[some arbitrary order].to_custom_sql_order(:description) }

    let(:expected) do
      "CASE
       WHEN description = 'some' THEN 0
       WHEN description = 'arbitrary' THEN 1
       WHEN description = 'order' THEN 2
       END".gsub("\n", '').squeeze
    end

    it { is_expected.to eq(expected) }
  end
end
