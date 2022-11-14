RSpec.describe PokerSession do
  it { should belong_to :stake }
  it { should belong_to :bet_structure }
  it { should belong_to :poker_variant }
  it { should have_many :hand_histories }

  subject { build :poker_session }

  describe '#game_type' do
    it 'describes the full game type of the session' do
      expect(subject.game_type).to eq "#{subject.stake.stake} #{subject.bet_structure.abbreviation}#{subject.poker_variant.abbreviation}"
    end
  end

  describe '#result' do
    it 'returns the buyin minus the cashout' do
      expect(subject.result).to eq(subject.cashout - subject.buyin)
    end

    it 'memoizes the result' do
      expect(subject).to receive(:cashout).once.and_call_original
      2.times { subject.result }
    end
  end

  describe '#duration' do
    it 'returns the end_time minus the start_time' do
      expect(subject.duration).to eq(subject.end_time - subject.start_time)
    end

    it 'memoizes the result' do
      expect(subject).to receive(:end_time).once.and_call_original
      2.times { subject.duration }
    end
  end

  describe '#hourly' do
    it 'returns the hourly rate, rounded to 2 decimal places' do
      expect(subject.hourly).to eq((subject.result.to_f / (subject.duration.to_f / 3600)).round(2))
    end

    it 'memoizes the result' do
      expect(subject).to receive(:result).once.and_call_original
      2.times { subject.hourly }
    end
  end

  describe '#hands_played' do
    subject { build :poker_session, :with_hand_histories }

    it 'returns the number of hands played during the session' do
      expect(subject.hands_played).to eq(subject.hand_histories.count)
    end

    it 'memoizes the result' do
      expect(subject).to receive(:hand_histories).once.and_call_original
      2.times { subject.hands_played }
    end
  end

  describe '#saw_flop' do
    subject { build :poker_session, :with_hand_histories_flops }

    it 'returns the number of hands in the session where a flop exists' do
      expect(subject.saw_flop).to eq(subject.hand_histories.where.not(flop: nil).count)
    end

    it 'memoizes the result' do
      expect(subject).to receive(:hand_histories).once.and_call_original
      2.times { subject.saw_flop }
    end
  end

  describe '#wtsd' do
    subject { build :poker_session, :with_hand_histories_showdowns }

    it 'returns the number of hands in the session that went to showdown' do
      expect(subject.wtsd).to eq(subject.hand_histories.where(showdown: true).count)
    end

    it 'memoizes the result' do
      expect(subject).to receive(:hand_histories).once.and_call_original
      2.times { subject.wtsd }
    end
  end

  describe '#wmsd' do
    subject { build :poker_session, :with_hand_histories_showdowns }

    it 'returns the number of hands in the session that went to showdown that won money' do
      expect(subject.wmsd).to eq(subject.hand_histories.where(showdown: true).where('result >= 0').count)
    end

    it 'memoizes the result' do
      expect(subject).to receive(:hand_histories).once.and_call_original
      2.times { subject.wmsd }
    end
  end

  describe '#vpip' do
    subject { build :poker_session }

    it 'returns the VPIP' do
      expect(subject.vpip).to eq(subject.hands_played.to_f / subject.hands_dealt.to_f)
    end

    it 'memoizes the result' do
      expect(subject).to receive(:hands_played).once.and_call_original
      2.times { subject.vpip }
    end
  end

  describe '.import' do
    context 'basic import' do
      it 'imports a PokerSession' do
        expect { described_class.import('2022-01-01', File.readlines('spec/data/poker_sessions/import_basic.txt').join) }.to change { PokerSession.count }.from(0).to(1)
      end
    end

    context 'bad game name' do
      it 'raises an exception' do
        expect do
          described_class.import('2022-01-01', File.readlines('spec/data/poker_sessions/import_bad_game_name.txt').join)
        end.to(
          raise_error(GameType::UnknownGameTypeException, /Unknown Game Type: UWOT/)
        )
      end
    end

    context 'end_time spans across dates' do
      it 'adjusts the end_time to belong to the following day' do
        described_class.import('2022-01-01', File.readlines('spec/data/poker_sessions/import_next_day_end_time.txt').join)
        expect(PokerSession.first.end_time.to_date).to eq(Date.parse('2022-01-02'))
      end
    end
  end

  context 'stats' do
    let(:ps) { double(described_class) }

    before { allow(described_class).to receive(:all).and_return(ps) }

    context 'session stats' do
      describe '.results' do
        it 'returns the sum of all results' do
          expect(ps).to receive(:sum).with('cashout - buyin').and_return(1)
          expect(described_class.results).to eq(1)
        end
      end

      describe '.duration' do
        it 'returns the sum of all durations' do
          expect(ps).to receive(:sum).with('end_time - start_time').and_return(1.hour)
          expect(described_class.duration).to eq(1.hour)
        end
      end

      describe '.hourly' do
        it 'returns the hourly of all sessions' do
          expect(described_class).to receive(:results).with(ps).and_return(1)
          expect(described_class).to receive(:duration).with(ps).and_return(2.hours)
          expect(described_class.hourly).to eq(0.5)
        end
      end

      describe '.pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(ps).to receive(:where).with('(cashout - buyin) > 0').and_return([0])
          expect(ps).to receive(:count).with(no_args).and_return(4)
          expect(described_class.pct_won).to eq(0.25)
        end
      end

      describe '.best' do
        it 'returns the best result' do
          expect(ps).to receive(:maximum).with('cashout - buyin').and_return(1)
          expect(described_class.best).to eq(1)
        end
      end

      describe '.worst' do
        it 'returns the worst result' do
          expect(ps).to receive(:minimum).with('cashout - buyin').and_return(1)
          expect(described_class.worst).to eq(1)
        end
      end

      describe '.avg_wins' do
        it 'returns the average of wins' do
          expect(ps).to receive(:where).with('(cashout - buyin) > 0').and_return(ps)
          expect(ps).to receive(:average).with('(cashout - buyin)').and_return(1.234)
          expect(described_class.avg_wins).to eq(1.23)
        end
      end

      describe '.avg_wins_median' do
        it 'returns the median average of wins' do
          expect(ps).to receive(:where).with('(cashout - buyin) > 0').and_return(ps)
          expect(ps).to receive(:pluck).with(Arel.sql('(cashout - buyin)')).and_return([1.234, 2.345, 3.456])
          expect(described_class.avg_wins_median).to eq(2.35)
        end
      end

      describe '.avg_losses' do
        it 'returns the average of losses' do
          expect(ps).to receive(:where).with('(cashout - buyin) < 0').and_return(ps)
          expect(ps).to receive(:average).with('(cashout - buyin)').and_return(-1.234)
          expect(described_class.avg_losses).to eq(-1.23)
        end
      end

      describe '.avg_losses_median' do
        it 'returns the median average of losses' do
          expect(ps).to receive(:where).with('(cashout - buyin) < 0').and_return(ps)
          expect(ps).to receive(:pluck).with(Arel.sql('(cashout - buyin)')).and_return([-1.234, -2.345, -3.456])
          expect(described_class.avg_losses_median).to eq(-2.35)
        end
      end

      describe '.avg' do
        it 'returns the average of all results' do
          expect(ps).to receive(:average).with('(cashout - buyin)').and_return(0.666)
          expect(described_class.avg).to eq(0.67)
        end
      end

      describe '.avg_median' do
        it 'returns the median average of all results' do
          expect(ps).to receive(:pluck).with(Arel.sql('(cashout - buyin)')).and_return([1, -2, 3])
          expect(described_class.avg_median).to eq(1.0)
        end
      end

      describe '.longest_win_streak' do
        it 'returns the size of the longest win streak' do
          expect(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([1, 2, -1, 3, 4, 5])
          expect(described_class.longest_win_streak).to eq(3)
        end
      end

      describe '.longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          expect(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([1, -2, -1, 3, -4, 5])
          expect(described_class.longest_loss_streak).to eq(2)
        end
      end

      describe '.hands_dealt' do
        it 'returns the sum of the number of hands dealt' do
          expect(ps).to receive(:sum).with(:hands_dealt).and_return(100)
          expect(described_class.hands_dealt).to eq(100)
        end
      end

      describe '.hands_played' do
        it 'returns the sum of the number of hands played' do
          expect(ps).to receive(:joins).with(:hand_histories).and_return(ps)
          expect(ps).to receive(:count).with('hand_histories.id').and_return(100)
          expect(described_class.hands_played).to eq(100)
        end
      end

      describe '.saw_flop' do
        it 'returns the sum of the number of hands that saw a flop' do
          expect(ps).to receive(:joins).with(:hand_histories).and_return(ps)
          expect(ps).to receive(:where).with(no_args).and_return(ps)
          expect(ps).to receive(:not).with(hand_histories: { flop: nil }).and_return(ps)
          expect(ps).to receive(:count).with('hand_histories.id').and_return(100)
          expect(described_class.saw_flop).to eq(100)
        end
      end

      describe '.wtsd' do
        it 'returns the sum of the number of hands that went to showdown' do
          expect(ps).to receive(:joins).with(:hand_histories).and_return(ps)
          expect(ps).to receive(:where).with(hand_histories: { showdown: true }).and_return(ps)
          expect(ps).to receive(:count).with('hand_histories.id').and_return(100)
          expect(described_class.wtsd).to eq(100)
        end
      end

      describe '.wmsd' do
        it 'returns the sum of the number of hands that won at showdown' do
          expect(ps).to receive(:joins).with(:hand_histories).and_return(ps)
          expect(ps).to receive(:where).with(hand_histories: { showdown: true }).and_return(ps)
          expect(ps).to receive(:where).with('hand_histories.result >= 0').and_return(ps)
          expect(ps).to receive(:count).with('hand_histories.id').and_return(100)
          expect(described_class.wmsd).to eq(100)
        end
      end

      describe '.vpip' do
        it 'returns the vpip across all sessions' do
          expect(ps).to receive(:where).with(no_args).and_return(ps)
          expect(ps).to receive(:not).with(hands_dealt: nil).and_return(ps)
          expect(described_class).to receive(:hands_played).with(ps).and_return(1)
          expect(described_class).to receive(:hands_dealt).with(ps).and_return(2)
          expect(described_class.vpip).to eq(0.5)
        end
      end
    end

    context 'daily stats' do
      before { allow(ps).to receive(:group_by_day).with(:start_time, series: false).and_return(ps) }

      describe '.daily_results' do
        it 'returns the sum of all results' do
          expect(ps).to receive(:sum).with('cashout - buyin').and_return({a: 1, b: 2})
          expect(described_class.daily_results).to eq([1, 2])
        end
      end

      describe '.daily_durations' do
        it 'returns the sum of all durations' do
          expect(ps).to receive(:sum).with('end_time - start_time').and_return({a: 1.hour, b: 2.hours})
          expect(described_class.daily_durations).to eq([1.hour, 2.hours])
        end
      end

      describe '.daily_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([1, -1, 2])
          expect(described_class.daily_pct_won).to eq(0.67)
        end
      end

      describe '.daily_best' do
        it 'returns the best result' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([1, 2, 3])
          expect(described_class.daily_best).to eq(3)
        end
      end

      describe '.daily_worst' do
        it 'returns the worst result' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([1, 2, 3])
          expect(described_class.daily_worst).to eq(1)
        end
      end

      describe '.daily_avg_wins' do
        it 'returns the average of wins' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([1, -2, 3])
          expect(described_class.daily_avg_wins).to eq(2.0)
        end
      end

      describe '.daily_avg_wins_median' do
        it 'returns the median average of wins' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([1, -2, 3, 4])
          expect(described_class.daily_avg_wins_median).to eq(3.0)
        end
      end

      describe '.daily_avg_losses' do
        it 'returns the average of losses' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([-1, -2, 3])
          expect(described_class.daily_avg_losses).to eq(-1.5)
        end
      end

      describe '.daily_avg_losses_median' do
        it 'returns the median average of losses' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([-1, -2, 3, -4])
          expect(described_class.daily_avg_losses_median).to eq(-2.0)
        end
      end

      describe '.daily_avg' do
        it 'returns the average of all results' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([-1, -2, 3, 4])
          expect(described_class.daily_avg).to eq(1.0)
        end
      end

      describe '.daily_avg_median' do
        it 'returns the median average of all results' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([-1, 3, -2, 4])
          expect(described_class.daily_avg_median).to eq(1.0)
        end
      end

      describe '.daily_longest_win_streak' do
        it 'returns the size of the longest win streak' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([1, 2, 3, 0, 6])
          expect(described_class.daily_longest_win_streak).to eq(3)
        end
      end

      describe '.daily_longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          expect(described_class).to receive(:daily_results).with(ps).and_return([-5, -2, -9, 1, 2, -1, 0, 6])
          expect(described_class.daily_longest_loss_streak).to eq(3)
        end
      end
    end

    context 'weekly stats' do
      before { allow(ps).to receive(:group_by_week).with(:start_time, series: false).and_return(ps) }

      describe '.weekly_results' do
        it 'returns the sum of all results' do
          expect(ps).to receive(:sum).with('cashout - buyin').and_return({a: 1, b: 2})
          expect(described_class.weekly_results).to eq([1, 2])
        end
      end

      describe '.weekly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([1, -1, 2])
          expect(described_class.weekly_pct_won).to eq(0.67)
        end
      end

      describe '.weekly_best' do
        it 'returns the best result' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([1, 2, 3])
          expect(described_class.weekly_best).to eq(3)
        end
      end

      describe '.weekly_worst' do
        it 'returns the worst result' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([1, 2, 3])
          expect(described_class.weekly_worst).to eq(1)
        end
      end

      describe '.weekly_avg_wins' do
        it 'returns the average of wins' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([1, -2, 3])
          expect(described_class.weekly_avg_wins).to eq(2.0)
        end
      end

      describe '.weekly_avg_wins_median' do
        it 'returns the median average of wins' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([1, -2, 3, 4])
          expect(described_class.weekly_avg_wins_median).to eq(3.0)
        end
      end

      describe '.weekly_avg_losses' do
        it 'returns the average of losses' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([-1, -2, 3])
          expect(described_class.weekly_avg_losses).to eq(-1.5)
        end
      end

      describe '.weekly_avg_losses_median' do
        it 'returns the median average of losses' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([-1, -2, 3, -4])
          expect(described_class.weekly_avg_losses_median).to eq(-2.0)
        end
      end

      describe '.weekly_avg' do
        it 'returns the average of all results' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([-1, -2, 3, 4])
          expect(described_class.weekly_avg).to eq(1.0)
        end
      end

      describe '.weekly_avg_median' do
        it 'returns the median average of all results' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([-1, 3, -2, 4])
          expect(described_class.weekly_avg_median).to eq(1.0)
        end
      end

      describe '.weekly_longest_win_streak' do
        it 'returns the size of the longest win streak' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([1, 2, 3, 0, 6])
          expect(described_class.weekly_longest_win_streak).to eq(3)
        end
      end

      describe '.weekly_longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          expect(described_class).to receive(:weekly_results).with(ps).and_return([-5, -2, -9, 1, 2, -1, 0, 6])
          expect(described_class.weekly_longest_loss_streak).to eq(3)
        end
      end
    end

    context 'monthly stats' do
      before { allow(ps).to receive(:group_by_month).with(:start_time, series: false).and_return(ps) }

      describe '.monthly_results' do
        it 'returns the sum of all results' do
          expect(ps).to receive(:sum).with('cashout - buyin').and_return({a: 1, b: 2})
          expect(described_class.monthly_results).to eq([1, 2])
        end
      end

      describe '.monthly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([1, -1, 2])
          expect(described_class.monthly_pct_won).to eq(0.67)
        end
      end

      describe '.monthly_best' do
        it 'returns the best result' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([1, 2, 3])
          expect(described_class.monthly_best).to eq(3)
        end
      end

      describe '.monthly_worst' do
        it 'returns the worst result' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([1, 2, 3])
          expect(described_class.monthly_worst).to eq(1)
        end
      end

      describe '.monthly_avg_wins' do
        it 'returns the average of wins' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([1, -2, 3])
          expect(described_class.monthly_avg_wins).to eq(2.0)
        end
      end

      describe '.monthly_avg_wins_median' do
        it 'returns the median average of wins' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([1, -2, 3, 4])
          expect(described_class.monthly_avg_wins_median).to eq(3.0)
        end
      end

      describe '.monthly_avg_losses' do
        it 'returns the average of losses' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([-1, -2, 3])
          expect(described_class.monthly_avg_losses).to eq(-1.5)
        end
      end

      describe '.monthly_avg_losses_median' do
        it 'returns the median average of losses' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([-1, -2, 3, -4])
          expect(described_class.monthly_avg_losses_median).to eq(-2.0)
        end
      end

      describe '.monthly_avg' do
        it 'returns the average of all results' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([-1, -2, 3, 4])
          expect(described_class.monthly_avg).to eq(1.0)
        end
      end

      describe '.monthly_avg_median' do
        it 'returns the median average of all results' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([-1, 3, -2, 4])
          expect(described_class.monthly_avg_median).to eq(1.0)
        end
      end

      describe '.monthly_longest_win_streak' do
        it 'returns the size of the longest win streak' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([1, 2, 3, 0, 6])
          expect(described_class.monthly_longest_win_streak).to eq(3)
        end
      end

      describe '.monthly_longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          expect(described_class).to receive(:monthly_results).with(ps).and_return([-5, -2, -9, 1, 2, -1, 0, 6])
          expect(described_class.monthly_longest_loss_streak).to eq(3)
        end
      end
    end

    context 'yearly stats' do
      before { allow(ps).to receive(:group_by_year).with(:start_time, series: false).and_return(ps) }

      describe '.yearly_results' do
        it 'returns the sum of all results' do
          expect(ps).to receive(:sum).with('cashout - buyin').and_return({a: 1, b: 2})
          expect(described_class.yearly_results).to eq([1, 2])
        end
      end

      describe '.yearly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([1, -1, 2])
          expect(described_class.yearly_pct_won).to eq(0.67)
        end
      end

      describe '.yearly_best' do
        it 'returns the best result' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([1, 2, 3])
          expect(described_class.yearly_best).to eq(3)
        end
      end

      describe '.yearly_worst' do
        it 'returns the worst result' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([1, 2, 3])
          expect(described_class.yearly_worst).to eq(1)
        end
      end

      describe '.yearly_avg_wins' do
        it 'returns the average of wins' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([1, -2, 3])
          expect(described_class.yearly_avg_wins).to eq(2.0)
        end
      end

      describe '.yearly_avg_wins_median' do
        it 'returns the median average of wins' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([1, -2, 3, 4])
          expect(described_class.yearly_avg_wins_median).to eq(3.0)
        end
      end

      describe '.yearly_avg_losses' do
        it 'returns the average of losses' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([-1, -2, 3])
          expect(described_class.yearly_avg_losses).to eq(-1.5)
        end
      end

      describe '.yearly_avg_losses_median' do
        it 'returns the median average of losses' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([-1, -2, 3, -4])
          expect(described_class.yearly_avg_losses_median).to eq(-2.0)
        end
      end

      describe '.yearly_avg' do
        it 'returns the average of all results' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([-1, -2, 3, 4])
          expect(described_class.yearly_avg).to eq(1.0)
        end
      end

      describe '.yearly_avg_median' do
        it 'returns the median average of all results' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([-1, 3, -2, 4])
          expect(described_class.yearly_avg_median).to eq(1.0)
        end
      end

      describe '.yearly_longest_win_streak' do
        it 'returns the size of the longest win streak' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([1, 2, 3, 0, 6])
          expect(described_class.yearly_longest_win_streak).to eq(3)
        end
      end

      describe '.yearly_longest_loss_streak' do
        it 'returns the size of the longest loss streak' do
          expect(described_class).to receive(:yearly_results).with(ps).and_return([-5, -2, -9, 1, 2, -1, 0, 6])
          expect(described_class.yearly_longest_loss_streak).to eq(3)
        end
      end
    end
  end
end
