RSpec.describe ApplicationController do
  it 'includes CLearance::Controller' do
    expect(ApplicationController.ancestors).to include(Clearance::Controller)
  end
end
