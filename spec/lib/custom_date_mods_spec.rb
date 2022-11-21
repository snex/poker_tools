# frozen_string_literal: true

RSpec.describe CustomDateMods do
  describe '#same_month?' do
    subject { Date.parse('2022-11-20').same_month?(new_d) }

    context 'when year and month are the same as target' do
      let(:new_d) { Date.parse('2022-11-01') }

      it { is_expected.to be(true) }
    end

    context 'when year is the same as target but month is different' do
      let(:new_d) { Date.parse('2022-10-01') }

      it { is_expected.to be(false) }
    end

    context 'when year is different but month is the same as target' do
      let(:new_d) { Date.parse('2021-11-01') }

      it { is_expected.to be(false) }
    end

    context 'when year and month are different from target' do
      let(:new_d) { Date.parse('2021-10-01') }

      it { is_expected.to be(false) }
    end
  end
end
