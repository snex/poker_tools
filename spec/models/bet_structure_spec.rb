# frozen_string_literal: true

RSpec.describe BetStructure do
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_uniqueness_of(:abbreviation) }
end
