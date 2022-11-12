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

  context 'session stats' do
    before do
      create :poker_session, buyin: 3953, cashout: 2685, start_time: DateTime.parse('2022-11-11 02:39 PST'), end_time: DateTime.parse('2022-11-11 05:01 PST'), hands_dealt: 1
      create :poker_session, buyin: 9998, cashout: 6048, start_time: DateTime.parse('2022-11-11 13:58 PST'), end_time: DateTime.parse('2022-11-12 00:34 PST')
      create :poker_session, buyin: 5240, cashout: 6674, start_time: DateTime.parse('2022-11-10 11:42 PST'), end_time: DateTime.parse('2022-11-10 13:52 PST'), hands_dealt: 1
      create :poker_session, buyin: 9779, cashout: 1028, start_time: DateTime.parse('2022-11-10 02:17 PST'), end_time: DateTime.parse('2022-11-10 23:16 PST')
    end

    context 'unfiltered' do
      describe '.results' do
        it 'returns the sum of all results' do
          expect(described_class.results).to eq(-12535)
        end
      end

      describe '.duration' do
        it 'returns the sum of all durations' do
          expect(described_class.duration).to eq(36.hours + 7.minutes)
        end
      end

      describe '.hourly' do
        it 'returns the hourly of all sessions' do
          expect(described_class.hourly).to eq(-347.07)
        end
      end

      describe '.pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.pct_won).to eq(0.25)
        end
      end

      describe '.best' do
        it 'returns the best result' do
          expect(described_class.best).to eq(1434)
        end
      end

      describe '.worst' do
        it 'returns the worst result' do
          expect(described_class.worst).to eq(-8751)
        end
      end

      describe '.avg_wins' do
        it 'returns the average of wins' do
          expect(described_class.avg_wins).to eq(1434.0)
        end
      end

      describe '.avg_wins_median' do
        it 'returns the median average of wins' do
          expect(described_class.avg_wins_median).to eq(1434.0)
        end
      end
    end

    context 'filtered' do
      let(:filter) { PokerSession.where(hands_dealt: 1) }

      describe '.results' do
        it 'returns the sum of all results' do
          expect(described_class.results(filter)).to eq(166)
        end
      end

      describe '.duration' do
        it 'returns the sum of all durations' do
          expect(described_class.duration(filter)).to eq(4.hours + 32.minutes)
        end
      end

      describe '.hourly' do
        it 'returns the hourly of all sessions' do
          expect(described_class.hourly(filter)).to eq(36.62)
        end
      end

      describe '.pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.pct_won(filter)).to eq(0.5)
        end
      end

      describe '.best' do
        it 'returns the best result' do
          expect(described_class.best(filter)).to eq(1434)
        end
      end

      describe '.worst' do
        it 'returns the worst result' do
          expect(described_class.worst(filter)).to eq(-1268)
        end
      end

      describe '.avg_wins' do
        it 'returns the average of wins' do
          expect(described_class.avg_wins(filter)).to eq(1434.0)
        end
      end

      describe '.avg_wins_median' do
        it 'returns the median average of wins' do
          expect(described_class.avg_wins_median(filter)).to eq(1434.0)
        end
      end
    end
  end

  context 'daily stats' do
    before do
      create :poker_session, buyin: 8149, cashout: 6863, start_time: DateTime.parse('2022-11-11 19:28 PST'), end_time: DateTime.parse('2022-11-11 22:24 PST'), hands_dealt: 1
      create :poker_session, buyin: 7541, cashout: 4194, start_time: DateTime.parse('2022-11-11 20:27 PST'), end_time: DateTime.parse('2022-11-12 00:02 PST')
      create :poker_session, buyin: 6346, cashout: 7729, start_time: DateTime.parse('2022-11-10 12:24 PST'), end_time: DateTime.parse('2022-11-10 23:52 PST'), hands_dealt: 1
      create :poker_session, buyin: 5246, cashout: 7055, start_time: DateTime.parse('2022-11-10 05:02 PST'), end_time: DateTime.parse('2022-11-10 18:41 PST')
    end

    context 'unfiltered' do
      describe '.daily_results' do
        it 'calculates the results' do
          expect(described_class.daily_results).to contain_exactly(-4633, 3192)
        end
      end

      describe '.daily_durations' do
        it 'returns the sum of all durations' do
          expect(described_class.daily_durations).to contain_exactly(6.hours + 31.minutes, 25.hours + 7.minutes)
        end
      end

      describe '.daily_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.daily_pct_won).to eq(0.5)
        end
      end

      describe '.daily_best' do
        it 'returns the best result' do
          expect(described_class.daily_best).to eq(3192)
        end
      end

      describe '.daily_worst' do
        it 'returns the worst result' do
          expect(described_class.daily_worst).to eq(-4633)
        end
      end

      describe '.daily_avg_wins' do
        it 'returns the average of wins' do
          expect(described_class.daily_avg_wins).to eq(3192.0)
        end
      end
    end

    context 'filtered' do
      let(:filter) { PokerSession.where(hands_dealt: 1) }

      describe '.daily_results' do
        it 'calculates the results' do
          expect(described_class.daily_results(filter)).to contain_exactly(-1286, 1383)
        end
      end

      describe '.daily_durations' do
        it 'returns the sum of all durations' do
          expect(described_class.daily_durations(filter)).to contain_exactly(2.hour + 56.minutes, 11.hours + 28.minutes)
        end
      end

      describe '.daily_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.daily_pct_won(filter)).to eq(0.5)
        end
      end

      describe '.daily_best' do
        it 'returns the best result' do
          expect(described_class.daily_best(filter)).to eq(1383)
        end
      end

      describe '.daily_worst' do
        it 'returns the worst result' do
          expect(described_class.daily_worst(filter)).to eq(-1286)
        end
      end

      describe '.daily_avg_wins' do
        it 'returns the average of wins' do
          expect(described_class.daily_avg_wins(filter)).to eq(1383.0)
        end
      end
    end
  end

  context 'weekly stats' do
    before do
      create :poker_session, buyin: 7710, cashout: 9364, start_time: DateTime.parse('2022-11-01 11:49 PST'), end_time: DateTime.parse('2022-11-01 13:39 PST'), hands_dealt: 1
      create :poker_session, buyin: 3692, cashout: 8640, start_time: DateTime.parse('2022-11-01 22:12 PST'), end_time: DateTime.parse('2022-11-01 22:53 PST')
      create :poker_session, buyin: 1591, cashout: 7491, start_time: DateTime.parse('2022-11-08 03:29 PST'), end_time: DateTime.parse('2022-11-08 16:14 PST'), hands_dealt: 1
      create :poker_session, buyin: 8048, cashout: 1996, start_time: DateTime.parse('2022-11-08 04:50 PST'), end_time: DateTime.parse('2022-11-08 18:15 PST')
    end

    context 'unfiltered' do
      describe '.weekly_results' do
        it 'calculates the results' do
          expect(described_class.weekly_results).to contain_exactly(6602, -152)
        end
      end

      describe '.weekly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.weekly_pct_won).to eq(0.5)
        end
      end

      describe '.weekly_best' do
        it 'returns the best result' do
          expect(described_class.weekly_best).to eq(6602)
        end
      end

      describe '.weekly_worst' do
        it 'returns the worst result' do
          expect(described_class.weekly_worst).to eq(-152)
        end
      end
    end

    context 'filtered' do
      let(:filter) { PokerSession.where(hands_dealt: 1) }

      describe '.weekly_results' do
        it 'calculates the results' do
          expect(described_class.weekly_results(filter)).to contain_exactly(1654, 5900)
        end
      end

      describe '.weekly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.weekly_pct_won(filter)).to eq(1.0)
        end
      end

      describe '.weekly_best' do
        it 'returns the best result' do
          expect(described_class.weekly_best(filter)).to eq(5900)
        end
      end

      describe '.weekly_worst' do
        it 'returns the worst result' do
          expect(described_class.weekly_worst(filter)).to eq(1654)
        end
      end
    end
  end

  context 'monthly stats' do
    before do
      create :poker_session, buyin: 6072, cashout: 5142, start_time: DateTime.parse('2022-10-01 10:10 PST'), end_time: DateTime.parse('2022-10-01 18:23 PST'), hands_dealt: 1
      create :poker_session, buyin: 5491, cashout: 5827, start_time: DateTime.parse('2022-10-01 23:25 PST'), end_time: DateTime.parse('2022-10-02 01:02 PST')
      create :poker_session, buyin: 8329, cashout: 3299, start_time: DateTime.parse('2022-11-08 06:09 PST'), end_time: DateTime.parse('2022-11-08 17:29'), hands_dealt: 1
      create :poker_session, buyin: 8480, cashout: 2753, start_time: DateTime.parse('2022-11-08 09:11 PST'), end_time: DateTime.parse('2022-11-08 16:54 PST')
    end

    context 'unfiltered' do
      describe '.monthly_results' do
        it 'calculates the results' do
          expect(described_class.monthly_results).to contain_exactly(-594, -10757)
        end
      end

      describe '.monthly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.monthly_pct_won).to eq(0.0)
        end
      end

      describe '.monthly_best' do
        it 'returns the best result' do
          expect(described_class.monthly_best).to eq(-594)
        end
      end

      describe '.monthly_worst' do
        it 'returns the worst result' do
          expect(described_class.monthly_worst).to eq(-10757)
        end
      end
    end

    context 'filtered' do
      let(:filter) { PokerSession.where(hands_dealt: 1) }

      describe '.monthly_results' do
        it 'calculates the results' do
          expect(described_class.monthly_results(filter)).to contain_exactly(-930, -5030)
        end
      end

      describe '.monthly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.monthly_pct_won(filter)).to eq(0.0)
        end
      end

      describe '.monthly_best' do
        it 'returns the best result' do
          expect(described_class.monthly_best(filter)).to eq(-930)
        end
      end

      describe '.monthly_worst' do
        it 'returns the worst result' do
          expect(described_class.monthly_worst(filter)).to eq(-5030)
        end
      end
    end
  end

  context 'yearly stats' do
    before do
      create :poker_session, buyin: 6441, cashout: 9688, start_time: DateTime.parse('2021-10-01 10:09 PST'), end_time: DateTime.parse('2021-10-01 17:47 PST'), hands_dealt: 1
      create :poker_session, buyin: 6956, cashout: 3138, start_time: DateTime.parse('2021-10-01 18:13 PST'), end_time: DateTime.parse('2021-10-02 01:15 PST')
      create :poker_session, buyin: 2224, cashout: 1232, start_time: DateTime.parse('2022-11-08 12:47 PST'), end_time: DateTime.parse('2022-11-08 23:20 PST'), hands_dealt: 1
      create :poker_session, buyin: 3309, cashout: 4259, start_time: DateTime.parse('2022-11-08 17:55 PST'), end_time: DateTime.parse('2022-11-08 21:26 PST')
    end

    context 'unfiltered' do
      describe '.yearly_results' do
        it 'calculates the results grouped by year' do
          expect(described_class.yearly_results).to contain_exactly(-571, -42)
        end
      end

      describe '.yearly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.yearly_pct_won).to eq(0.0)
        end
      end

      describe '.yearly_best' do
        it 'returns the best result' do
          expect(described_class.yearly_best).to eq(-42)
        end
      end

      describe '.yearly_worst' do
        it 'returns the worst result' do
          expect(described_class.yearly_worst).to eq(-571)
        end
      end
    end

    context 'filtered' do
      let(:filter) { PokerSession.where(hands_dealt: 1) }

      describe '.yearly_results' do
        it 'calculates the results grouped by year' do
          expect(described_class.yearly_results(filter)).to contain_exactly(3247, -992)
        end
      end

      describe '.yearly_pct_won' do
        it 'returns the percentage of winning sessions' do
          expect(described_class.yearly_pct_won(filter)).to eq(0.5)
        end
      end

      describe '.yearly_best' do
        it 'returns the best result' do
          expect(described_class.yearly_best(filter)).to eq(3247)
        end
      end

      describe '.yearly_worst' do
        it 'returns the worst result' do
          expect(described_class.yearly_worst(filter)).to eq(-992)
        end
      end
    end
  end
end
