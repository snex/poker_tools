# frozen_string_literal: true

RSpec.describe User do
  it 'includes Clearance::User' do
    expect(described_class.ancestors).to include(Clearance::User)
  end
end
