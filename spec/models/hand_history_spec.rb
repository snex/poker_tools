# frozen_string_literal: true

RSpec.describe HandHistory do
  it { is_expected.to belong_to(:hand) }
  it { is_expected.to belong_to(:position) }
  it { is_expected.to belong_to(:bet_size) }
  it { is_expected.to belong_to(:table_size) }
  it { is_expected.to belong_to(:poker_session).optional(true) }
  it { is_expected.to have_many(:villain_hands).dependent(:delete_all) }

  describe '.saw_flop' do
    subject { described_class.saw_flop }

    let!(:hh) { create_list(:hand_history, 2, :with_flop) }

    before { create(:hand_history) }

    it { is_expected.to eq(hh) }
  end

  describe '.saw_turn' do
    subject { described_class.saw_turn }

    let!(:hh) { create_list(:hand_history, 2, :with_turn) }

    before { create(:hand_history) }

    it { is_expected.to eq(hh) }
  end

  describe '.saw_river' do
    subject { described_class.saw_river }

    let!(:hh) { create_list(:hand_history, 2, :with_river) }

    before { create(:hand_history) }

    it { is_expected.to eq(hh) }
  end

  describe '.showdown' do
    subject { described_class.showdown }

    let!(:hh) { create_list(:hand_history, 2, :with_showdown) }

    before { create(:hand_history) }

    it { is_expected.to eq(hh) }
  end

  describe '.all_in' do
    subject { described_class.all_in }

    let!(:hh) { create_list(:hand_history, 2, :with_all_in) }

    before { create(:hand_history) }

    it { is_expected.to eq(hh) }
  end

  describe '.won' do
    subject { described_class.won }

    let!(:hh) { create_list(:hand_history, 2, result: 100) }

    before { create(:hand_history, result: -100) }

    it { is_expected.to eq(hh) }
  end

  describe '.lost' do
    subject { described_class.lost }

    let!(:hh) { create_list(:hand_history, 2, result: -100) }

    before { create(:hand_history, result: 100) }

    it { is_expected.to eq(hh) }
  end

  describe '.with_poker_sessions' do
    subject { described_class.with_poker_sessions(ps) }

    let(:ps) { create(:poker_session) }
    let!(:hh) { create_list(:hand_history, 2, poker_session: ps) }

    before { create(:hand_history) }

    it { is_expected.to eq(hh) }
  end

  describe '.custom_filter' do
    subject { described_class.custom_filter(params) }

    let(:hh) { create(:hand_history, :with_flop, :with_turn, :with_river, :with_showdown, :with_all_in) }

    context 'when bet_size is passed' do
      context 'when filter matches' do
        let(:params) { { bet_size: hh.bet_size.id } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { bet_size: 0 } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when hand is passed' do
      context 'when filter matches' do
        let(:params) { { hand: hh.hand.id } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { hand: 0 } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when position is passed' do
      context 'when filter matches' do
        let(:params) { { position: hh.position.id } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { position: 0 } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when stake is passed' do
      context 'when filter matches' do
        let(:params) { { stake: hh.poker_session.stake.id } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { stake: 0 } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when table_size is passed' do
      context 'when filter matches' do
        let(:params) { { table_size: hh.table_size.id } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { table_size: 0 } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when to and from are passed' do
      context 'when filter matches' do
        let(:params) { { from: hh.poker_session.start_time - 1.day, to: hh.poker_session.start_time + 1.day } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { from: hh.poker_session.start_time + 1.day, to: hh.poker_session.start_time - 1.day } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when only from is passed' do
      context 'when filter matches' do
        let(:params) { { from: hh.poker_session.start_time - 1.day } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { from: hh.poker_session.start_time + 1.day } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when only to is passed' do
      context 'when filter matches' do
        let(:params) { { to: hh.poker_session.start_time + 1.day } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { to: hh.poker_session.start_time - 1.day } }

        it { is_expected.to eq([]) }
      end
    end

    # NOTE: since these params come directly from controllers, booleans are assumed to be strings
    # with 'true' or 'false' as values. this applies to 'flop', 'turn', 'river', 'showdown', and 'all_in'

    context 'when flop is passed' do
      context 'when filter matches' do
        let(:params) { { flop: 'true' } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { flop: 'false' } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when turn is passed' do
      context 'when filter matches' do
        let(:params) { { turn: 'true' } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { turn: 'false' } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when river is passed' do
      context 'when filter matches' do
        let(:params) { { river: 'true' } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { river: 'false' } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when showdown is passed' do
      context 'when filter matches' do
        let(:params) { { showdown: 'true' } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { showdown: 'false' } }

        it { is_expected.to eq([]) }
      end
    end

    context 'when all_in is passed' do
      context 'when filter matches' do
        let(:params) { { all_in: 'true' } }

        it { is_expected.to eq([hh]) }
      end

      context 'when filter doesnt match' do
        let(:params) { { all_in: 'false' } }

        it { is_expected.to eq([]) }
      end
    end
  end

  describe '.import' do
    let!(:ps) { create(:poker_session) }

    context 'when given a valid file' do
      it 'imports a HandHistory' do
        expect do
          described_class.import(ps, File.readlines('spec/data/hand_histories/import_basic.txt').join)
        end.to change(described_class, :count).from(0).to(1)
      end
    end

    context 'when "limp" is passed in as bet_size' do
      it 'imports a HandHistory' do
        described_class.import(ps, File.readlines('spec/data/hand_histories/import_limp.txt').join)
        expect(described_class.first.bet_size).to eq(BetSize.find_by(bet_size: 1))
      end
    end
  end
end
