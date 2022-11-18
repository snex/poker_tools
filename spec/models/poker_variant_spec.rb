# frozen_string_literal: true

RSpec.describe PokerVariant do
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_uniqueness_of(:abbreviation) }
end
