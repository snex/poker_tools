RSpec.describe AuthorizedPagesController do
  it { should use_before_action(:require_login) }
end
