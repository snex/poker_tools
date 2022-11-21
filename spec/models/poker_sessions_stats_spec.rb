# frozen_string_literal: true

RSpec.describe PokerSessionsStats do
  let(:ps) { class_double(PokerSession) }
  let(:hh) { class_double(HandHistory) }

  before do
    allow(PokerSession).to receive(:all).and_return(ps)
    allow(HandHistory).to receive(:with_poker_sessions).with(ps).and_return(hh)
  end

  describe '.results' do
    subject { PokerSession.results(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before { allow(ps).to receive(:sum).with('cashout - buyin').and_return(1) }

      it { is_expected.to eq(1) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(ps).to receive(:"group_by_#{group_by}").with(:start_time, { series: false }).and_return(ps)
        allow(ps).to receive(:sum).with('cashout - buyin').and_return({ a: 1, b: 2 })
      end

      it { is_expected.to eq([1, 2]) }
    end
  end

  describe '.duration' do
    subject { PokerSession.duration(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before { allow(ps).to receive(:sum).with('end_time - start_time').and_return(1.hour) }

      it { is_expected.to eq(1.hour) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(ps).to receive(:"group_by_#{group_by}").with(:start_time, { series: false }).and_return(ps)
        allow(ps).to receive(:sum).with('end_time - start_time').and_return({ a: 1.hour, b: 2.hours })
      end

      it { is_expected.to eq([1.hour, 2.hours]) }
    end
  end

  describe '.hourly' do
    subject { PokerSession.hourly }

    before do
      allow(PokerSession).to receive(:results).with(:all, ps).and_return(1)
      allow(PokerSession).to receive(:duration).with(:all, ps).and_return(2.hours)
    end

    it { is_expected.to eq(0.5) }
  end

  describe '.pct_won' do
    subject { PokerSession.pct_won(group_by) }

    it 'returns the percentage of winning sessions' do
      allow(ps).to receive(:where).with('(cashout - buyin) > 0').and_return([1])
      allow(ps).to receive(:count).and_return(4)
      expect(PokerSession.pct_won).to eq(0.25)
    end

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:where).with('(cashout - buyin) > 0').and_return([1])
        allow(ps).to receive(:count).with(no_args).and_return(2)
      end

      it { is_expected.to eq(0.5) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3])
      end

      it { is_expected.to eq(0.67) }
    end
  end

  describe '.best' do
    subject { PokerSession.best(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before { allow(ps).to receive(:maximum).with('cashout - buyin').and_return(1) }

      it { is_expected.to eq(1) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3])
      end

      it { is_expected.to eq(3) }
    end
  end

  describe '.worst' do
    subject { PokerSession.worst(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before { allow(ps).to receive(:minimum).with('cashout - buyin').and_return(1) }

      it { is_expected.to eq(1) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3])
      end

      it { is_expected.to eq(-2) }
    end
  end

  describe '.avg_wins' do
    subject { PokerSession.avg_wins(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:where).with('(cashout - buyin) > 0').and_return(ps)
        allow(ps).to receive(:average).with('cashout - buyin').and_return(1)
      end

      it { is_expected.to eq(1) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3])
      end

      it { is_expected.to eq(2) }
    end
  end

  describe '.avg_wins_median' do
    subject { PokerSession.avg_wins_median(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:where).with('(cashout - buyin) > 0').and_return(ps)
        allow(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([2, 4, 2, 5, 1])
      end

      it { is_expected.to eq(2) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3, -4])
      end

      it { is_expected.to eq(2) }
    end
  end

  describe '.avg_losses' do
    subject { PokerSession.avg_losses(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:where).with('(cashout - buyin) < 0').and_return(ps)
        allow(ps).to receive(:average).with(Arel.sql('cashout - buyin')).and_return(-2)
      end

      it { is_expected.to eq(-2) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([-1, -2, 3])
      end

      it { is_expected.to eq(-1.5) }
    end
  end

  describe '.avg_losses_median' do
    subject { PokerSession.avg_losses_median(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:where).with('(cashout - buyin) < 0').and_return(ps)
        allow(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([2, 4, 2, 5, 1])
      end

      it { is_expected.to eq(2) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3, -4])
      end

      it { is_expected.to eq(-3) }
    end
  end

  describe '.avg' do
    subject { PokerSession.avg(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:average).with('cashout - buyin').and_return(2)
      end

      it { is_expected.to eq(2) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3, -4])
      end

      it { is_expected.to eq(-0.5) }
    end
  end

  describe '.avg_median' do
    subject { PokerSession.avg_median(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([1, 3, 5])
      end

      it { is_expected.to eq(3) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3, -4])
      end

      it { is_expected.to eq(-0.5) }
    end
  end

  describe '.longest_win_streak' do
    subject { PokerSession.longest_win_streak(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([1, 3, 5, -1, 1])
      end

      it { is_expected.to eq(3) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, 3, -4])
      end

      it { is_expected.to eq(1) }
    end
  end

  describe '.longest_loss_streak' do
    subject { PokerSession.longest_loss_streak(group_by) }

    context 'when group_by is :all' do
      let(:group_by) { :all }

      before do
        allow(ps).to receive(:pluck).with(Arel.sql('cashout - buyin')).and_return([1, 3, 5, -1, 1])
      end

      it { is_expected.to eq(1) }
    end

    context 'when group_by is a named time period' do
      let(:group_by) { %i[day week month year].sample }

      before do
        allow(PokerSession).to receive(:results).with(group_by, ps).and_return([1, -2, -3, -4])
      end

      it { is_expected.to eq(3) }
    end
  end

  describe '.hands_dealt' do
    it 'returns the sum of the number of hands dealt' do
      allow(ps).to receive(:sum).and_return(100)
      expect(PokerSession.hands_dealt).to eq(100)
    end
  end

  describe '.hands_played' do
    it 'returns the sum of the number of hands played' do
      allow(HandHistory).to receive(:with_poker_sessions).with(ps).and_return([1, 1])
      expect(PokerSession.hands_played).to eq(2)
    end
  end

  describe '.saw_flop' do
    it 'returns the sum of the number of hands that saw a flop' do
      allow(hh).to receive(:saw_flop).and_return([1, 1])
      expect(PokerSession.saw_flop).to eq(2)
    end
  end

  describe '.wtsd' do
    it 'returns the sum of the number of hands that went to showdown' do
      allow(hh).to receive(:showdown).and_return([1, 1])
      expect(PokerSession.wtsd).to eq(2)
    end
  end

  describe '.wmsd' do
    it 'returns the sum of the number of hands that won at showdown' do
      allow(hh).to receive(:won).and_return(hh)
      allow(hh).to receive(:showdown).and_return([1, 1])
      expect(PokerSession.wmsd).to eq(2)
    end
  end

  describe '.vpip' do
    it 'returns the vpip across all sessions' do
      allow(PokerSession).to receive(:all).and_call_original
      allow(PokerSession).to receive(:hands_played).and_return(1)
      allow(PokerSession).to receive(:hands_dealt).and_return(2)
      expect(PokerSession.vpip).to eq(0.5)
    end
  end
end
