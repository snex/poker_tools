# frozen_string_literal: true

RSpec.describe GameType do
  describe '.new' do
    let(:gt) { described_class.new(input) }

    context 'when determining the stake' do
      subject { gt.stake }

      let(:input) { '2/5 NL' }

      it { is_expected.to eq(Stake.find_by(stake: '2/5')) }
    end

    context 'when determining the bet_structure' do
      subject { gt.bet_structure }

      context 'when input is NL' do
        let(:input) { '2/5 NL' }

        it { is_expected.to eq(BetStructure.find_by(name: 'No Limit')) }
      end

      context 'when input is BigO' do
        let(:input) { '2/5 BigO' }

        it { is_expected.to eq(BetStructure.find_by(name: 'Pot Limit')) }
      end

      context 'when input is PLO' do
        let(:input) { '2/5 PLO' }

        it { is_expected.to eq(BetStructure.find_by(name: 'Pot Limit')) }
      end

      context 'when input is PLDBomb' do
        let(:input) { '2/5 PLDBomb' }

        it { is_expected.to eq(BetStructure.find_by(name: 'Pot Limit')) }
      end
    end

    context 'when determining the poker_variant' do
      subject { gt.poker_variant }

      context 'when input is NL' do
        let(:input) { '2/5 NL' }

        it { is_expected.to eq(PokerVariant.find_by(name: 'Texas Holdem')) }
      end

      context 'when input is BigO' do
        let(:input) { '2/5 BigO' }

        it { is_expected.to eq(PokerVariant.find_by(name: 'BigO')) }
      end

      context 'when input is PLO' do
        let(:input) { '2/5 PLO' }

        it { is_expected.to eq(PokerVariant.find_by(name: 'Omaha')) }
      end

      context 'when input is PLDBomb' do
        let(:input) { '2/5 PLDBomb' }

        it { is_expected.to eq(PokerVariant.find_by(name: 'Double Board Bomb Pots')) }
      end
    end

    context 'when invalid string is passed' do
      subject { -> { gt } }

      context 'when no game type supplied' do
        let(:input) { '2/5 ' }

        it 'raises and exception' do
          expect { gt }.to raise_error(described_class::UnknownGameTypeException, /Unknown Game Type: /)
        end
      end

      context 'when an invalid game type supplied' do
        let(:input) { '2/5 UWOT' }

        it 'raises and exception' do
          expect { gt }.to raise_error(described_class::UnknownGameTypeException, /Unknown Game Type: UWOT/)
        end
      end
    end
  end
end
