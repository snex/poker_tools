# frozen_string_literal: true

RSpec.describe FileImporter do
  describe '.import' do
    context 'when a good file is supplied' do
      it 'imports a PokerSession' do
        expect do
          described_class.import('2022-01-01', 'spec/data/file_importer/import_basic.txt')
        end.to change(PokerSession, :count).from(0).to(1)
      end

      it 'imports a HandHistory' do
        expect do
          described_class.import('2022-01-01', 'spec/data/file_importer/import_basic.txt')
        end.to change(HandHistory, :count).from(0).to(1)
      end

      it 'associates the HandHistory to the PokerSession' do
        described_class.import('2022-01-01', 'spec/data/file_importer/import_basic.txt')
        expect(HandHistory.first.poker_session).to eq(PokerSession.first)
      end
    end
  end
end
