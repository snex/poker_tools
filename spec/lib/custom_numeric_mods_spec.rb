# frozen_string_literal: true

RSpec.describe CustomNumericMods do
  describe '#to_elapsed_time' do
    subject { val.to_elapsed_time }

    context 'with an int' do
      let(:val) { 12_000 }

      it { is_expected.to eq('3:20') }
    end

    context 'with a float' do
      let(:val) { 12_000.0 }

      it { is_expected.to eq('3:20') }
    end
  end
end
