RSpec.describe User do
  it 'includes Clearance::User' do
    expect(User.ancestors).to include(Clearance::User)
  end
end
