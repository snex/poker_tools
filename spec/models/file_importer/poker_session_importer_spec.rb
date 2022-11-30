# frozen_string_literal: true

RSpec.describe FileImporter::PokerSessionImporter do
  describe '.import' do
    subject(:import) { described_class.import('2022-01-01', file_fixture(filename).read.strip) }

    before do
      create(
        :game_type,
        stake:         Stake.find_or_create_by!(stake: '1/2'),
        bet_structure: BetStructure.find_by(name: 'No Limit'),
        poker_variant: PokerVariant.find_by(name: 'Texas Holdem')
      )
    end

    context 'when a good file is supplied' do
      let(:filename) { 'poker_sessions/import_basic.txt' }

      it 'imports a PokerSession' do
        expect { import }.to change(PokerSession, :count).from(0).to(1)
      end
    end

    context 'when no hands_dealt is supplied' do
      let(:filename) { 'poker_sessions/import_no_hands.txt' }

      it 'imports a PokerSession' do
        expect { import }.to change(PokerSession, :count).from(0).to(1)
      end

      it 'has nil for the hands_dealt' do
        import
        expect(PokerSession.first.hands_dealt).to be_nil
      end
    end

    context 'when bad game name is supplied' do
      let(:filename) { 'poker_sessions/import_bad_game_name.txt' }

      it 'raises an exception' do
        expect { import }.to(
          raise_error(GameType::UnknownGameTypeException, %r{Unknown Game Type: 1/2 UWOT})
        )
      end
    end

    context 'when end_time spans across dates' do
      let(:filename) { 'poker_sessions/import_next_day_end_time.txt' }

      it 'adjusts the end_time to belong to the following day' do
        import
        expect(PokerSession.first.end_time.to_date).to eq(Date.parse('2022-01-02'))
      end
    end

    context 'when the game name is a case-insensitive match' do
      let(:filename) { 'poker_sessions/import_case_insensitive_game_type.txt' }

      it 'imports a PokerSession' do
        expect { import }.to change(PokerSession, :count).from(0).to(1)
      end
    end
  end
end
