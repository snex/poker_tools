RSpec.describe HandHistory do
  it { should belong_to(:hand) }
  it { should belong_to(:position) }
  it { should belong_to(:bet_size) }
  it { should belong_to(:table_size) }
  it { should belong_to(:poker_session).optional(true) }
  it { should have_many(:villain_hands).dependent(:delete_all) }

  describe '#custom_filter' do
    let(:hh) { create :hand_history, :with_flop, :with_turn, :with_river, :with_showdown, :with_all_in }

    it 'filters on bet_size' do
      expect(described_class.custom_filter(bet_size: hh.bet_size.id)).to eq([hh])
      expect(described_class.custom_filter(bet_size: 0)).to eq([])
    end

    it 'filters on hand' do
      expect(described_class.custom_filter(hand: hh.hand.id)).to eq([hh])
      expect(described_class.custom_filter(hand: 0)).to eq([])
    end

    it 'filters on position' do
      expect(described_class.custom_filter(position: hh.position.id)).to eq([hh])
      expect(described_class.custom_filter(position: 0)).to eq([])
    end

    it 'filters on stake' do
      expect(described_class.custom_filter(stake: hh.poker_session.stake.id)).to eq([hh])
      expect(described_class.custom_filter(stake: 0)).to eq([])
    end

    it 'filters on table_size' do
      expect(described_class.custom_filter(table_size: hh.table_size.id)).to eq([hh])
      expect(described_class.custom_filter(table_size: 0)).to eq([])
    end

    it 'filters on 2 dates' do
      expect(described_class.custom_filter(from: hh.poker_session.start_time - 1.day, to: hh.poker_session.start_time + 1.day)).to eq([hh])
      expect(described_class.custom_filter(from: hh.poker_session.start_time + 1.day, to: hh.poker_session.start_time + 2.days)).to eq([])
    end

    it 'filters on from date' do
      expect(described_class.custom_filter(from: hh.poker_session.start_time - 1.day)).to eq([hh])
      expect(described_class.custom_filter(from: hh.poker_session.start_time + 1.day)).to eq([])
    end

    it 'filters on to date' do
      expect(described_class.custom_filter(to: hh.poker_session.start_time + 1.day)).to eq([hh])
      expect(described_class.custom_filter(to: hh.poker_session.start_time - 1.day)).to eq([])
    end

    it 'filters on flop' do
      # note - since these params come directly from controllers, booleans are assumed to be strings
      # with 'true' or 'false' as values
      expect(described_class.custom_filter(flop: 'true')).to eq([hh])
      expect(described_class.custom_filter(flop: 'false')).to eq([])
    end

    it 'filters on turn' do
      expect(described_class.custom_filter(turn: 'true')).to eq([hh])
      expect(described_class.custom_filter(turn: 'false')).to eq([])
    end

    it 'filters on river' do
      expect(described_class.custom_filter(river: 'true')).to eq([hh])
      expect(described_class.custom_filter(river: 'false')).to eq([])
    end

    it 'filters on showdown' do
      expect(described_class.custom_filter(showdown: 'true')).to eq([hh])
      expect(described_class.custom_filter(showdown: 'false')).to eq([])
    end

    it 'filters on all_in' do
      expect(described_class.custom_filter(all_in: 'true')).to eq([hh])
      expect(described_class.custom_filter(all_in: 'false')).to eq([])
    end
  end

  describe '.import' do
    let!(:ps) { create :poker_session }

    context 'basic import' do
      it 'imports a HandHistory' do
        expect { described_class.import(ps, File.readlines('spec/data/hand_histories/import_basic.txt').join) }.to change { HandHistory.count }.from(0).to(1)
      end
    end

    context 'convert limp to bet_size 1' do
      it 'imports a HandHistory' do
        described_class.import(ps, File.readlines('spec/data/hand_histories/import_limp.txt').join)
        expect(HandHistory.first.bet_size).to eq(BetSize.find_by_bet_size(1))
      end
    end
  end
end
