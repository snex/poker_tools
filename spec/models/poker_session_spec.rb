# frozen_string_literal: true

RSpec.describe PokerSession do
  it { is_expected.to belong_to :stake }
  it { is_expected.to belong_to :bet_structure }
  it { is_expected.to belong_to :poker_variant }
  it { is_expected.to have_many :hand_histories }

  describe 'memoized instance methods' do
    before do
      allow(ps).to receive(:stake).and_call_original
      allow(ps).to receive(:cashout).and_call_original
      allow(ps).to receive(:end_time).and_call_original
      allow(ps).to receive(:result).and_call_original
      allow(ps).to receive(:hand_histories).and_call_original
      2.times { s }
    end

    describe '#game_type' do
      subject(:s) { ps.game_type }

      let(:ps) { build(:poker_session) }

      it { is_expected.to eq("#{ps.stake.stake} #{ps.bet_structure.abbreviation}#{ps.poker_variant.abbreviation}") }

      it 'memoizes the result' do
        expect(ps).to have_received(:stake).with(no_args).once
      end
    end

    describe '#result' do
      subject(:s) { ps.result }

      let(:ps) { create(:poker_session, buyin: 100, cashout: 200) }

      it { is_expected.to eq(100) }

      it 'memoizes the result' do
        expect(ps).to have_received(:cashout).with(no_args).once
      end
    end

    describe '#duration' do
      subject(:s) { ps.duration }

      let(:ps) { create(:poker_session, start_time: DateTime.now, end_time: DateTime.now + 1.hour) }

      it { is_expected.to eq(1.hour) }

      it 'memoizes the result' do
        expect(ps).to have_received(:end_time).with(no_args).once
      end
    end

    describe '#hourly' do
      subject(:s) { ps.hourly }

      let(:ps) do
        create(:poker_session, buyin: 100, cashout: 200, start_time: DateTime.now, end_time: DateTime.now + 1.hour)
      end

      it { is_expected.to eq(100.0) }

      it 'memoizes the result' do
        expect(ps).to have_received(:result).with(no_args).once
      end
    end

    describe '#hands_played' do
      subject(:s) { ps.hands_played }

      let(:ps) { create(:poker_session, :with_hand_histories) }

      it { is_expected.to eq(5) }

      it 'memoizes the result' do
        expect(ps).to have_received(:hand_histories).once
      end
    end

    describe '#saw_flop' do
      subject(:s) { ps.saw_flop }

      let(:ps) { create(:poker_session, :with_hand_histories_flops) }

      it { is_expected.to eq(2) }

      it 'memoizes the result' do
        expect(ps).to have_received(:hand_histories).once
      end
    end

    describe '#wtsd' do
      subject(:s) { ps.wtsd }

      let(:ps) { create(:poker_session, :with_hand_histories_showdowns) }

      it { is_expected.to eq(2) }

      it 'memoizes the result' do
        expect(ps).to have_received(:hand_histories).once
      end
    end

    describe '#wmsd' do
      subject(:s) { ps.wmsd }

      let(:ps) { create(:poker_session, :with_hand_histories_showdowns) }

      it { is_expected.to eq(1) }

      it 'memoizes the result' do
        expect(ps).to have_received(:hand_histories).once
      end
    end

    describe '#vpip' do
      subject(:s) { ps.vpip }

      let(:ps) { create(:poker_session, :with_hand_histories, hands_dealt: 10) }

      it { is_expected.to eq(0.5) }

      it 'memoizes the result' do
        expect(ps).to have_received(:hand_histories).once
      end
    end
  end

  context 'with class level iterable dates' do
    before do
      create(:poker_session, start_time: DateTime.parse('2020-12-25 16:02 PST'), buyin: 500, cashout: 1000)
      ps = create(:poker_session, start_time: DateTime.parse('2021-02-01 05:00 PST'), buyin: 1000, cashout: 2100)
      create(:hand_history, poker_session: ps, result: 1000)
    end

    describe '.iterable_years' do
      subject { described_class.iterable_years }

      it { is_expected.to eq([2021, 2020]) }
    end

    describe '.iterable_months' do
      subject { described_class.iterable_months }

      it { is_expected.to eq([Date.parse('2021-02-01'), Date.parse('2021-01-01'), Date.parse('2020-12-01')]) }
    end
  end
end
