class AuthorizedPagesController < ApplicationController
  before_action :require_login
end
