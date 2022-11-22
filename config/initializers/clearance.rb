# frozen_string_literal: true

Clearance.configure do |config|
  config.allow_sign_up = false
  config.cookie_expiration = ->(_cookies) { 1.year.from_now.utc }
  config.httponly = true
  config.mailer_sender = 'snex@xens.org'
  config.password_strategy = Clearance::PasswordStrategies::BCrypt
  config.redirect_url = '/'
  config.rotate_csrf_on_sign_in = true
  config.secure_cookie = !Rails.env.test?
  config.signed_cookie = true
  config.cookie_domain = ->(request) { request.host }
end
