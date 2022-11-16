RSpec.describe GameType do
  describe '.new' do
    subject { described_class.new('2/5 NL') }

    context 'setting the bet_structure' do
      context 'NL' do
        context 'input is NL' do
          it 'sets the bet_structure to NL' do
            expect(subject.bet_structure).to eq(BetStructure.find_by_name('No Limit'))
          end
        end
      end

      context 'PL' do
        context 'input is BigO' do
          subject { described_class.new('2/5 BigO') }

          it 'sets the bet_structure to PL' do
            expect(subject.bet_structure).to eq(BetStructure.find_by_name('Pot Limit'))
          end
        end

        context 'input is PLO' do
          subject { described_class.new('2/5 PLO') }

          it 'sets the bet_structure to PL' do
            expect(subject.bet_structure).to eq(BetStructure.find_by_name('Pot Limit'))
          end
        end

        context 'input is PLDBomb' do
          subject { described_class.new('5 PLDBomb') }

          it 'sets the bet_structure to PL' do
            expect(subject.bet_structure).to eq(BetStructure.find_by_name('Pot Limit'))
          end
        end
      end
    end

    context 'setting the poker_variant' do
      context 'Texas Holdem' do
        context 'input is NL' do
          it 'sets the poker_variant to Texas Holdem' do
            expect(subject.poker_variant).to eq(PokerVariant.find_by_name('Texas Holdem'))
          end
        end
      end

      context 'BigO' do
        context 'input is BigO' do
          subject { described_class.new('2/5 BigO') }

          it 'sets the poker_variant to BigO' do
            expect(subject.poker_variant).to eq(PokerVariant.find_by_name('BigO'))
          end
        end
      end

      context 'Omaha' do
        context 'input is PLO' do
          subject { described_class.new('2/5 PLO') }

          it 'sets the poker_variant to Omaha' do
            expect(subject.poker_variant).to eq(PokerVariant.find_by_name('Omaha'))
          end
        end
      end

      context 'Double Board Bomb Pots' do
        context 'input is PLDBomb' do
          subject { described_class.new('2/5 PLDBomb') }

          it 'sets the poker_variant to Double Board Bomb Pots' do
            expect(subject.poker_variant).to eq(PokerVariant.find_by_name('Double Board Bomb Pots'))
          end
        end
      end
    end

    context 'unknown game type' do
      context 'no game type supplied' do
        subject { described_class.new('2/5 ') }

        it 'raises an exception' do
          expect { subject }.to raise_error(described_class::UnknownGameTypeException, /Unknown Game Type: /)
        end
      end

      context 'invalid game type supplied' do
        subject { described_class.new('2/5 UWOT') }

        it 'raises an exception' do
          expect { subject }.to raise_error(described_class::UnknownGameTypeException, /Unknown Game Type: UWOT/)
        end
      end
    end

    context 'setting the stake' do
      it 'sets the stake' do
        expect(subject.stake).to eq(Stake.find_by_stake('2/5'))
      end
    end
  end
end
