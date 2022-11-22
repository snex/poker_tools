# frozen_string_literal: true

class AuthorizedPagesController < ApplicationController
  before_action :require_login
end
