# frozen_string_literal: true

RSpec.describe GameType do
  it { is_expected.to belong_to(:bet_structure) }
  it { is_expected.to belong_to(:poker_variant) }
  it { is_expected.to belong_to(:stake) }

  describe 'validations' do
    before { create(:game_type) }

    it { is_expected.to validate_uniqueness_of(:game_type) }
    it { is_expected.to validate_uniqueness_of(:bet_structure_id).scoped_to(%i[poker_variant_id stake_id]) }
  end

  describe 'before save hook' do
    let(:gt) { build(:game_type) }

    it 'saves game_type string' do
      expected = "#{gt.stake.stake} #{gt.bet_structure.abbreviation}#{gt.poker_variant.abbreviation}"
      expect { gt.save }.to change(gt, :game_type).from(nil).to(expected)
    end
  end

  describe '#to_s' do
    subject { game_type.to_s }

    let!(:game_type) do
      create(
        :game_type,
        stake:         Stake.find_or_create_by!(stake: '1/2'),
        bet_structure: BetStructure.find_by(name: 'No Limit'),
        poker_variant: PokerVariant.find_by(name: 'Texas Holdem')
      )
    end

    it { is_expected.to eq('1/2 NLHE') }
  end
end
