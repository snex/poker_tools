RSpec.describe ApplicationController do
  it 'includes CLearance::Controller' do
    expect(described_class.ancestors).to include(Clearance::Controller)
  end
end
