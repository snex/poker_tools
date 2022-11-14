RSpec.describe HandHistory do
  it { should belong_to(:hand) }
  it { should belong_to(:position) }
  it { should belong_to(:bet_size) }
  it { should belong_to(:table_size) }
  it { should belong_to(:poker_session).optional(true) }
  it { should have_many(:villain_hands).dependent(:delete_all) }

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
