# frozen_string_literal: true

require "rails_helper"
require "support/features/clearance_helpers"

RSpec.feature "Visitor signs in" do
  scenario "with valid email and password" do
    create_user "user@example.com", "password"
    sign_in_with "user@example.com", "password"

    expect_user_to_be_signed_in
  end

  scenario "with valid mixed-case email and password " do
    create_user "user.name@example.com", "password"
    sign_in_with "User.Name@example.com", "password"

    expect_user_to_be_signed_in
  end

  scenario "tries with invalid password" do
    create_user "user@example.com", "password"
    sign_in_with "user@example.com", "wrong_password"

    expect_user_to_be_signed_out
  end

  scenario "tries with invalid email" do
    sign_in_with "unknown.email@example.com", "password"

    expect_user_to_be_signed_out
  end

  private

  def create_user(email, password)
    FactoryBot.create(:user, email: email, password: password)
  end
end
