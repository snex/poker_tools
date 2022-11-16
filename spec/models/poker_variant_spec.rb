# frozen_string_literal: true

RSpec.describe PokerVariant do
  it { should validate_uniqueness_of(:name) }
  it { should validate_uniqueness_of(:abbreviation) }
end
