# frozen_string_literal: true

RSpec.describe FileImporter::HandHistoryImporter do
  describe '.import' do
    subject(:import) { described_class.import(ps, file_fixture(filename).read.strip) }

    let!(:ps) { create(:poker_session) }

    context 'when given a valid file' do
      let(:filename) { 'hand_histories/import_basic.txt' }

      it 'imports a HandHistory' do
        expect { import }.to change(HandHistory, :count).from(0).to(1)
      end
    end

    context 'when "limp" is passed in as bet_size' do
      let(:filename) { 'hand_histories/import_limp.txt' }

      it 'imports a HandHistory with bet_size = 1' do
        import
        expect(HandHistory.first.bet_size).to eq(BetSize.find_by(bet_size: 1))
      end
    end

    context 'when there is no showdown (Issue #72)' do
      let(:filename) { 'hand_histories/import_no_showdown_issue_72.txt' }

      it 'imports a HandHistory' do
        expect { import }.to change(HandHistory, :count).from(0).to(1)
      end
    end

    context 'when the status line is missing' do
      let(:filename) { 'hand_histories/import_no_status_line.txt' }
      let(:expected) { file_fixture('hand_histories/import_no_status_line_expected_error.txt').read.strip }

      it 'raises an error' do
        expect { import }.to raise_error(FileImporter::HandHistoryParser::HandHistoryParseException, expected)
      end
    end
  end
end
