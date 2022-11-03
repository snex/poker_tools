class AuthorizedPagesController < ApplicationController
  before_action :log_dat_shit
  before_action :require_login

  def log_dat_shit
    Rails.logger.error("wtf: #{clearance_session.current_user}")
    Rails.logger.error("wtf: #{session.keys}")
    Rails.logger.error("wtf: #{cookies.map { |cookie| cookie.join('=') }.join("\n")}")
  end
end
