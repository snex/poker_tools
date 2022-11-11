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
    it 'returns the end_time minus the start_time as an integer' do
      expect(subject.duration).to eq((subject.end_time - subject.start_time).to_i)
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

  describe '.result' do
    before { create_list :poker_session, 5 }

    context 'all sessions' do
      it 'returns the sum of all results' do
        expect(described_class.result).to eq(PokerSession.all.sum('cashout - buyin'))
      end
    end

    context 'filtered sessions' do
      it 'returns the sum of all results' do
        expect(described_class.result(PokerSession.where(id: PokerSession.first))).to eq(PokerSession.first.result)
      end
    end
  end
end
