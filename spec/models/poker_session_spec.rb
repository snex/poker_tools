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

  describe '.import' do
    context 'when a good file is supplied' do
      it 'imports a PokerSession' do
        expect do
          described_class.import('2022-01-01', File.readlines('spec/data/poker_sessions/import_basic.txt').join)
        end.to change(described_class, :count).from(0).to(1)
      end
    end

    context 'when bad game name is supplied' do
      it 'raises an exception' do
        expect do
          described_class.import('2022-01-01', File.readlines('spec/data/poker_sessions/import_bad_game_name.txt').join)
        end.to(
          raise_error(GameType::UnknownGameTypeException, /Unknown Game Type: UWOT/)
        )
      end
    end

    context 'when end_time spans across dates' do
      it 'adjusts the end_time to belong to the following day' do
        described_class.import(
          '2022-01-01',
          File.readlines('spec/data/poker_sessions/import_next_day_end_time.txt').join
        )
        expect(described_class.first.end_time.to_date).to eq(Date.parse('2022-01-02'))
      end
    end
  end

  describe 'stats' do
    let(:ps) { class_double(described_class) }
    let(:hh) { class_double(HandHistory) }

    before do
      allow(described_class).to receive(:all).and_return(ps)
      allow(HandHistory).to receive(:with_poker_sessions).with(ps).and_return(hh)
    end

    context 'when session stats are calculated' do
      describe '.results' do
        it 'returns the sum of all results' do
          allow(ps).to receive(:sum).with('cashout - buyin').and_return(1)
          expect(described_class.results).to eq(1)
        end
      end

      describe '.duration' do
        it 'returns the sum of all durations' do
          allow(ps).to receive(:sum).with('end_time - start_time').and_return(1.hour)
          expect(described_class.duration).to eq(1.hour)
        end
      end

      describe '.hourly' do
        it 'returns the hourly of all sessions' do
          allow(described_class).to receive(:results).with(ps).and_return(1)
          allow(described_class).to receive(:duration).with(ps).and_return(2.hours)
          expect(described_class.hourly).to eq(0.5)
        end
      end

      describe '.pct_won' do
        it 'returns the percentage of winning sessions' do
          allow(ps).to receive(:where).with('(cashout - buyin) > 0').and_return([1])
          allow(ps).to receive(:count).and_return(4)
          expect(described_class.pct_won).to eq(0.25)
        end
      end

      describe '.best' do
        it 'returns the best result' do
          allow(ps).to receive(:maximum).with('cashout - buyin').and_return(1)
          expect(described_class.best).to eq(1)
        end
      end

      describe '.worst' do
        it 'returns the worst result' do
          allow(ps).to receive(:minimum).with('cashout - buyin').and_return(1)
          expect(described_class.worst).to eq(1)
        end
      end

      describe '.avg_wins' do
        it 'returns the average of wins' do
          allow(ps).to receive(:where).with('(cashout - buyin) > 0').and_return(ps)
          allow(ps).to receive(:average).with('(cashout - buyin)').and_return(1.234)
          expect(described_class.avg_wins).to eq(1.23)
        end
      end

      describe '.avg_wins_median' do
        it 'returns the median average of wins' do
          allow(ps).to receive(:where).with('(cashout - buyin) > 0').and_return(ps)
          allow(ps).to receive(:pluck).and_return([1.234, 2.345, 3.456])
          expect(described_class.avg_wins_median).to eq(2.35)
        end
      end

      describe '.avg_losses' do
        it 'returns the average of losses' do
          allow(ps).to receive(:where).with('(cashout - buyin) < 0').and_return(ps)
          allow(ps).to receive(:average).with('(cashout - buyin)').and_return(-1.234)
          expect(described_class.avg_losses).to eq(-1.23)
        end
      end

      describe '.avg_losses_median' do
        it 'returns the median average of losses' do
          allow(ps).to receive(:where).with('(cashout - buyin) < 0').and_return(ps)
          allow(ps).to receive(:pluck).and_return([-1.234, -2.345, -3.456])
          expect(described_class.avg_losses_median).to eq(-2.35)
        end
      end

      describe '.avg' do
        it 'returns the average of all results' do
          allow(ps).to receive(:average).with('(cashout - buyin)').and_return(0.666)
          expect(described_class.avg).to eq(0.67)
        end
      end

      describe '.avg_median' do
        it 'returns the median average of all results' do
          allow(ps).to receive(:pluck).with(Arel.sql('(cashout - buyin)')).and_return([1, -2, 3])
          expect(described_class.avg_median).to eq(1.0)
        end
      end

      describe '.longest_win_streak' do
        it 'returns the size of the longest win streak' do
          allow(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([1, 2, -1, 3, 4, 5])
          expect(described_class.longest_win_streak).to eq(3)
        end
      end

      describe '.longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          allow(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([1, -2, -1, 3, -4, 5])
          expect(described_class.longest_loss_streak).to eq(2)
        end
      end

      describe '.hands_dealt' do
        it 'returns the sum of the number of hands dealt' do
          allow(ps).to receive(:sum).and_return(100)
          expect(described_class.hands_dealt).to eq(100)
        end
      end

      describe '.hands_played' do
        it 'returns the sum of the number of hands played' do
          allow(HandHistory).to receive(:with_poker_sessions).with(ps).and_return([1, 1])
          expect(described_class.hands_played).to eq(2)
        end
      end

      describe '.saw_flop' do
        it 'returns the sum of the number of hands that saw a flop' do
          allow(hh).to receive(:saw_flop).and_return([1, 1])
          expect(described_class.saw_flop).to eq(2)
        end
      end

      describe '.wtsd' do
        it 'returns the sum of the number of hands that went to showdown' do
          allow(hh).to receive(:showdown).and_return([1, 1])
          expect(described_class.wtsd).to eq(2)
        end
      end

      describe '.wmsd' do
        it 'returns the sum of the number of hands that won at showdown' do
          allow(hh).to receive(:won).and_return(hh)
          allow(hh).to receive(:showdown).and_return([1, 1])
          expect(described_class.wmsd).to eq(2)
        end
      end

      describe '.vpip' do
        it 'returns the vpip across all sessions' do
          allow(described_class).to receive(:all).and_call_original
          allow(described_class).to receive(:hands_played).and_return(1)
          allow(described_class).to receive(:hands_dealt).and_return(2)
          expect(described_class.vpip).to eq(0.5)
        end
      end
    end

    context 'when daily stats are calculated' do
      before { allow(ps).to receive(:group_by_day).with(:start_time, series: false).and_return(ps) }

      describe '.daily_results' do
        it 'returns the sum of all results' do
          allow(described_class).to receive(:results).with(ps).and_return({ a: 1, b: 2 })
          expect(described_class.daily_results).to eq([1, 2])
        end
      end

      describe '.daily_durations' do
        it 'returns the sum of all durations' do
          allow(described_class).to receive(:duration).with(ps).and_return({ a: 1.hour, b: 2.hours })
          expect(described_class.daily_durations).to eq([1.hour, 2.hours])
        end
      end

      describe '.daily_pct_won' do
        it 'returns the percentage of winning sessions' do
          allow(described_class).to receive(:daily_results).and_return([1, -1, 2])
          expect(described_class.daily_pct_won).to eq(0.67)
        end
      end

      describe '.daily_best' do
        it 'returns the best result' do
          allow(described_class).to receive(:daily_results).and_return([1, 2, 3])
          expect(described_class.daily_best).to eq(3)
        end
      end

      describe '.daily_worst' do
        it 'returns the worst result' do
          allow(described_class).to receive(:daily_results).and_return([1, 2, 3])
          expect(described_class.daily_worst).to eq(1)
        end
      end

      describe '.daily_avg_wins' do
        it 'returns the average of wins' do
          allow(described_class).to receive(:daily_results).and_return([1, -2, 3])
          expect(described_class.daily_avg_wins).to eq(2.0)
        end
      end

      describe '.daily_avg_wins_median' do
        it 'returns the median average of wins' do
          allow(described_class).to receive(:daily_results).and_return([1, -2, 3, 4])
          expect(described_class.daily_avg_wins_median).to eq(3.0)
        end
      end

      describe '.daily_avg_losses' do
        it 'returns the average of losses' do
          allow(described_class).to receive(:daily_results).and_return([-1, -2, 3])
          expect(described_class.daily_avg_losses).to eq(-1.5)
        end
      end

      describe '.daily_avg_losses_median' do
        it 'returns the median average of losses' do
          allow(described_class).to receive(:daily_results).and_return([-1, -2, 3, -4])
          expect(described_class.daily_avg_losses_median).to eq(-2.0)
        end
      end

      describe '.daily_avg' do
        it 'returns the average of all results' do
          allow(described_class).to receive(:daily_results).and_return([-1, -2, 3, 4])
          expect(described_class.daily_avg).to eq(1.0)
        end
      end

      describe '.daily_avg_median' do
        it 'returns the median average of all results' do
          allow(described_class).to receive(:daily_results).and_return([-1, 3, -2, 4])
          expect(described_class.daily_avg_median).to eq(1.0)
        end
      end

      describe '.daily_longest_win_streak' do
        it 'returns the size of the longest win streak' do
          allow(described_class).to receive(:daily_results).and_return([1, 2, 3, 0, 6])
          expect(described_class.daily_longest_win_streak).to eq(3)
        end
      end

      describe '.daily_longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          allow(described_class).to receive(:daily_results).and_return([-5, -2, -9, 1, 2, -1, 0, 6])
          expect(described_class.daily_longest_loss_streak).to eq(3)
        end
      end
    end

    context 'when weekly stats are calculated' do
      before { allow(ps).to receive(:group_by_week).with(:start_time, series: false).and_return(ps) }

      describe '.weekly_results' do
        it 'returns the sum of all results' do
          allow(described_class).to receive(:results).with(ps).and_return({ a: 1, b: 2 })
          expect(described_class.weekly_results).to eq([1, 2])
        end
      end

      describe '.weekly_pct_won' do
        it 'returns the percentage of winning sessions' do
          allow(described_class).to receive(:weekly_results).and_return([1, -1, 2])
          expect(described_class.weekly_pct_won).to eq(0.67)
        end
      end

      describe '.weekly_best' do
        it 'returns the best result' do
          allow(described_class).to receive(:weekly_results).and_return([1, 2, 3])
          expect(described_class.weekly_best).to eq(3)
        end
      end

      describe '.weekly_worst' do
        it 'returns the worst result' do
          allow(described_class).to receive(:weekly_results).and_return([1, 2, 3])
          expect(described_class.weekly_worst).to eq(1)
        end
      end

      describe '.weekly_avg_wins' do
        it 'returns the average of wins' do
          allow(described_class).to receive(:weekly_results).and_return([1, -2, 3])
          expect(described_class.weekly_avg_wins).to eq(2.0)
        end
      end

      describe '.weekly_avg_wins_median' do
        it 'returns the median average of wins' do
          allow(described_class).to receive(:weekly_results).and_return([1, -2, 3, 4])
          expect(described_class.weekly_avg_wins_median).to eq(3.0)
        end
      end

      describe '.weekly_avg_losses' do
        it 'returns the average of losses' do
          allow(described_class).to receive(:weekly_results).and_return([-1, -2, 3])
          expect(described_class.weekly_avg_losses).to eq(-1.5)
        end
      end

      describe '.weekly_avg_losses_median' do
        it 'returns the median average of losses' do
          allow(described_class).to receive(:weekly_results).and_return([-1, -2, 3, -4])
          expect(described_class.weekly_avg_losses_median).to eq(-2.0)
        end
      end

      describe '.weekly_avg' do
        it 'returns the average of all results' do
          allow(described_class).to receive(:weekly_results).and_return([-1, -2, 3, 4])
          expect(described_class.weekly_avg).to eq(1.0)
        end
      end

      describe '.weekly_avg_median' do
        it 'returns the median average of all results' do
          allow(described_class).to receive(:weekly_results).and_return([-1, 3, -2, 4])
          expect(described_class.weekly_avg_median).to eq(1.0)
        end
      end

      describe '.weekly_longest_win_streak' do
        it 'returns the size of the longest win streak' do
          allow(described_class).to receive(:weekly_results).and_return([1, 2, 3, 0, 6])
          expect(described_class.weekly_longest_win_streak).to eq(3)
        end
      end

      describe '.weekly_longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          allow(described_class).to receive(:weekly_results).and_return([-5, -2, -9, 1, 2, -1, 0, 6])
          expect(described_class.weekly_longest_loss_streak).to eq(3)
        end
      end
    end

    context 'when monthly stats are calculated' do
      before { allow(ps).to receive(:group_by_month).with(:start_time, series: false).and_return(ps) }

      describe '.monthly_results' do
        it 'returns the sum of all results' do
          allow(described_class).to receive(:results).with(ps).and_return({ a: 1, b: 2 })
          expect(described_class.monthly_results).to eq([1, 2])
        end
      end

      describe '.monthly_pct_won' do
        it 'returns the percentage of winning sessions' do
          allow(described_class).to receive(:monthly_results).and_return([1, -1, 2])
          expect(described_class.monthly_pct_won).to eq(0.67)
        end
      end

      describe '.monthly_best' do
        it 'returns the best result' do
          allow(described_class).to receive(:monthly_results).and_return([1, 2, 3])
          expect(described_class.monthly_best).to eq(3)
        end
      end

      describe '.monthly_worst' do
        it 'returns the worst result' do
          allow(described_class).to receive(:monthly_results).and_return([1, 2, 3])
          expect(described_class.monthly_worst).to eq(1)
        end
      end

      describe '.monthly_avg_wins' do
        it 'returns the average of wins' do
          allow(described_class).to receive(:monthly_results).and_return([1, -2, 3])
          expect(described_class.monthly_avg_wins).to eq(2.0)
        end
      end

      describe '.monthly_avg_wins_median' do
        it 'returns the median average of wins' do
          allow(described_class).to receive(:monthly_results).and_return([1, -2, 3, 4])
          expect(described_class.monthly_avg_wins_median).to eq(3.0)
        end
      end

      describe '.monthly_avg_losses' do
        it 'returns the average of losses' do
          allow(described_class).to receive(:monthly_results).and_return([-1, -2, 3])
          expect(described_class.monthly_avg_losses).to eq(-1.5)
        end
      end

      describe '.monthly_avg_losses_median' do
        it 'returns the median average of losses' do
          allow(described_class).to receive(:monthly_results).and_return([-1, -2, 3, -4])
          expect(described_class.monthly_avg_losses_median).to eq(-2.0)
        end
      end

      describe '.monthly_avg' do
        it 'returns the average of all results' do
          allow(described_class).to receive(:monthly_results).and_return([-1, -2, 3, 4])
          expect(described_class.monthly_avg).to eq(1.0)
        end
      end

      describe '.monthly_avg_median' do
        it 'returns the median average of all results' do
          allow(described_class).to receive(:monthly_results).and_return([-1, 3, -2, 4])
          expect(described_class.monthly_avg_median).to eq(1.0)
        end
      end

      describe '.monthly_longest_win_streak' do
        it 'returns the size of the longest win streak' do
          allow(described_class).to receive(:monthly_results).and_return([1, 2, 3, 0, 6])
          expect(described_class.monthly_longest_win_streak).to eq(3)
        end
      end

      describe '.monthly_longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          allow(described_class).to receive(:monthly_results).and_return([-5, -2, -9, 1, 2, -1, 0, 6])
          expect(described_class.monthly_longest_loss_streak).to eq(3)
        end
      end
    end

    context 'when yearly stats are calculated' do
      before { allow(ps).to receive(:group_by_year).with(:start_time, series: false).and_return(ps) }

      describe '.yearly_results' do
        it 'returns the sum of all results' do
          allow(described_class).to receive(:results).with(ps).and_return({ a: 1, b: 2 })
          expect(described_class.yearly_results).to eq([1, 2])
        end
      end

      describe '.yearly_pct_won' do
        it 'returns the percentage of winning sessions' do
          allow(described_class).to receive(:yearly_results).and_return([1, -1, 2])
          expect(described_class.yearly_pct_won).to eq(0.67)
        end
      end

      describe '.yearly_best' do
        it 'returns the best result' do
          allow(described_class).to receive(:yearly_results).and_return([1, 2, 3])
          expect(described_class.yearly_best).to eq(3)
        end
      end

      describe '.yearly_worst' do
        it 'returns the worst result' do
          allow(described_class).to receive(:yearly_results).and_return([1, 2, 3])
          expect(described_class.yearly_worst).to eq(1)
        end
      end

      describe '.yearly_avg_wins' do
        it 'returns the average of wins' do
          allow(described_class).to receive(:yearly_results).and_return([1, -2, 3])
          expect(described_class.yearly_avg_wins).to eq(2.0)
        end
      end

      describe '.yearly_avg_wins_median' do
        it 'returns the median average of wins' do
          allow(described_class).to receive(:yearly_results).and_return([1, -2, 3, 4])
          expect(described_class.yearly_avg_wins_median).to eq(3.0)
        end
      end

      describe '.yearly_avg_losses' do
        it 'returns the average of losses' do
          allow(described_class).to receive(:yearly_results).and_return([-1, -2, 3])
          expect(described_class.yearly_avg_losses).to eq(-1.5)
        end
      end

      describe '.yearly_avg_losses_median' do
        it 'returns the median average of losses' do
          allow(described_class).to receive(:yearly_results).and_return([-1, -2, 3, -4])
          expect(described_class.yearly_avg_losses_median).to eq(-2.0)
        end
      end

      describe '.yearly_avg' do
        it 'returns the average of all results' do
          allow(described_class).to receive(:yearly_results).and_return([-1, -2, 3, 4])
          expect(described_class.yearly_avg).to eq(1.0)
        end
      end

      describe '.yearly_avg_median' do
        it 'returns the median average of all results' do
          allow(described_class).to receive(:yearly_results).and_return([-1, 3, -2, 4])
          expect(described_class.yearly_avg_median).to eq(1.0)
        end
      end

      describe '.yearly_longest_win_streak' do
        it 'returns the size of the longest win streak' do
          allow(described_class).to receive(:yearly_results).and_return([1, 2, 3, 0, 6])
          expect(described_class.yearly_longest_win_streak).to eq(3)
        end
      end

      describe '.yearly_longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          allow(described_class).to receive(:yearly_results).and_return([-5, -2, -9, 1, 2, -1, 0, 6])
          expect(described_class.yearly_longest_loss_streak).to eq(3)
        end
      end
    end
  end
end
