# frozen_string_literal: true

RSpec.describe FileImporter::HandHistoryImporter do
  describe '.import' do
    let!(:ps) { create(:poker_session) }

    context 'when given a valid file' do
      it 'imports a HandHistory' do
        expect do
          described_class.import(ps, file_fixture('hand_histories/import_basic.txt').read.strip)
        end.to change(HandHistory, :count).from(0).to(1)
      end
    end

    context 'when "limp" is passed in as bet_size' do
      it 'imports a HandHistory' do
        described_class.import(ps, file_fixture('hand_histories/import_limp.txt').read.strip)
        expect(HandHistory.first.bet_size).to eq(BetSize.find_by(bet_size: 1))
      end
    end
  end
end
