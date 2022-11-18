# frozen_string_literal: true

RSpec.describe AuthorizedPagesController do
  it { is_expected.to use_before_action(:require_login) }
end
