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

  describe '.filter_bet_size' do
    subject { described_class.filter_bet_size(bet_size) }

    let(:hh) { create(:hand_history) }

    context 'when bet_size is nil' do
      let(:bet_size) { nil }

      it { is_expected.to eq([hh]) }
    end

    context 'when bet_size is passed, filter_matches' do
      let(:bet_size) { hh.bet_size.id }

      it { is_expected.to eq([hh]) }
    end

    context 'when bet_size is passed, filter doesnt match' do
      let(:bet_size) { 0 }

      it { is_expected.to eq([]) }
    end
  end

  describe '.filter_hand' do
    subject { described_class.filter_hand(hand) }

    let(:hh) { create(:hand_history) }

    context 'when hand is nil' do
      let(:hand) { nil }

      it { is_expected.to eq([hh]) }
    end

    context 'when hand is passed, filter_matches' do
      let(:hand) { hh.hand.id }

      it { is_expected.to eq([hh]) }
    end

    context 'when hand is passed, filter doesnt match' do
      let(:hand) { 0 }

      it { is_expected.to eq([]) }
    end
  end

  describe '.filter_position' do
    subject { described_class.filter_position(position) }

    let(:hh) { create(:hand_history) }

    context 'when position is nil' do
      let(:position) { nil }

      it { is_expected.to eq([hh]) }
    end

    context 'when position is passed, filter_matches' do
      let(:position) { hh.position.id }

      it { is_expected.to eq([hh]) }
    end

    context 'when position is passed, filter doesnt match' do
      let(:position) { 0 }

      it { is_expected.to eq([]) }
    end
  end

  describe '.filter_stake' do
    subject { described_class.filter_stake(stake) }

    let(:hh) { create(:hand_history) }

    context 'when stake is nil' do
      let(:stake) { nil }

      it { is_expected.to eq([hh]) }
    end

    context 'when stake is passed, filter_matches' do
      let(:stake) { hh.poker_session.game_type.stake.id }

      it { is_expected.to eq([hh]) }
    end

    context 'when stake is passed, filter doesnt match' do
      let(:stake) { 0 }

      it { is_expected.to eq([]) }
    end
  end

  describe '.filter_table_size' do
    subject { described_class.filter_table_size(table_size) }

    let(:hh) { create(:hand_history) }

    context 'when table_size is nil' do
      let(:table_size) { nil }

      it { is_expected.to eq([hh]) }
    end

    context 'when table_size is passed, filter_matches' do
      let(:table_size) { hh.table_size.id }

      it { is_expected.to eq([hh]) }
    end

    context 'when table_size is passed, filter doesnt match' do
      let(:table_size) { 0 }

      it { is_expected.to eq([]) }
    end
  end

  describe '.filter_times' do
    subject { described_class.filter_times(from, to) }

    let(:hh) { create(:hand_history) }

    context 'when from and to are passed, filter matches' do
      let(:from) { hh.poker_session.start_time - 1.day }
      let(:to) { hh.poker_session.start_time + 1.day }

      it { is_expected.to eq([hh]) }
    end

    context 'when from and to are passed, filter doesnt' do
      let(:from) { hh.poker_session.start_time + 1.day }
      let(:to) { hh.poker_session.start_time - 1.day }

      it { is_expected.to eq([]) }
    end

    context 'when only from is passed, filter_matches' do
      let(:from) { hh.poker_session.start_time - 1.day }
      let(:to) { nil }

      it { is_expected.to eq([hh]) }
    end

    context 'when only from is passed, filter_doesnt match' do
      let(:from) { hh.poker_session.start_time + 1.day }
      let(:to) { nil }

      it { is_expected.to eq([]) }
    end

    context 'when only to is passed, filter matches' do
      let(:from) { nil }
      let(:to) { hh.poker_session.start_time + 1.day }

      it { is_expected.to eq([hh]) }
    end

    context 'when only to is passed, filter doesnt match' do
      let(:from) { nil }
      let(:to) { hh.poker_session.start_time - 1.day }

      it { is_expected.to eq([]) }
    end

    context 'when neither from or to are passed' do
      let(:from) { nil }
      let(:to) { nil }

      it { is_expected.to eq([]) }
    end
  end

  describe '.filter_flop' do
    subject { described_class.filter_flop(flop) }

    let(:hh1) { create(:hand_history, :with_flop) }
    let(:hh2) { create(:hand_history) }

    context 'when flop is nil' do
      let(:flop) { nil }

      it { is_expected.to eq([hh1, hh2]) }
    end

    context 'when flop is true' do
      let(:flop) { 'true' }

      it { is_expected.to eq([hh1]) }
    end

    context 'when flop is false' do
      let(:flop) { 'false' }

      it { is_expected.to eq([hh2]) }
    end
  end

  describe '.filter_turn' do
    subject { described_class.filter_turn(turn) }

    let(:hh1) { create(:hand_history, :with_turn) }
    let(:hh2) { create(:hand_history) }

    context 'when turn is nil' do
      let(:turn) { nil }

      it { is_expected.to eq([hh1, hh2]) }
    end

    context 'when turn is true' do
      let(:turn) { 'true' }

      it { is_expected.to eq([hh1]) }
    end

    context 'when turn is false' do
      let(:turn) { 'false' }

      it { is_expected.to eq([hh2]) }
    end
  end

  describe '.filter_river' do
    subject { described_class.filter_river(river) }

    let(:hh1) { create(:hand_history, :with_river) }
    let(:hh2) { create(:hand_history) }

    context 'when river is nil' do
      let(:river) { nil }

      it { is_expected.to eq([hh1, hh2]) }
    end

    context 'when river is true' do
      let(:river) { 'true' }

      it { is_expected.to eq([hh1]) }
    end

    context 'when river is false' do
      let(:river) { 'false' }

      it { is_expected.to eq([hh2]) }
    end
  end

  describe '.filter_showdown' do
    subject { described_class.filter_showdown(showdown) }

    let(:hh1) { create(:hand_history, :with_showdown) }
    let(:hh2) { create(:hand_history) }

    context 'when showdown is nil' do
      let(:showdown) { nil }

      it { is_expected.to eq([hh1, hh2]) }
    end

    context 'when showdown is true' do
      let(:showdown) { 'true' }

      it { is_expected.to eq([hh1]) }
    end

    context 'when showdown is false' do
      let(:showdown) { 'false' }

      it { is_expected.to eq([hh2]) }
    end
  end

  describe '.filter_all_in' do
    subject { described_class.filter_all_in(all_in) }

    let(:hh1) { create(:hand_history, :with_all_in) }
    let(:hh2) { create(:hand_history) }

    context 'when all_in is nil' do
      let(:all_in) { nil }

      it { is_expected.to eq([hh1, hh2]) }
    end

    context 'when all_in is true' do
      let(:all_in) { 'true' }

      it { is_expected.to eq([hh1]) }
    end

    context 'when all_in is false' do
      let(:all_in) { 'false' }

      it { is_expected.to eq([hh2]) }
    end
  end
end
