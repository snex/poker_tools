source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false
gem 'haml', '~> 5.0'
gem 'bootstrap', '~> 4.6'
gem 'font-awesome-rails', '~> 4.7'
gem 'active_link_to', '~> 1.0'
gem 'passenger', '~> 6.0'
gem 'descriptive_statistics', '~> 2.0', require: 'descriptive_statistics/safe'
gem 'ajax-datatables-rails', git: 'https://github.com/jbox-web/ajax-datatables-rails.git'
gem 'groupdate', '~> 5.0'
gem 'arel_extensions', '~> 2.0'
gem 'guard', '~> 2.0'
gem 'guard-rake', '~> 1.0'
gem 'simple_calendar', '~> 2.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'mina'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data' #, platforms: [:mingw, :mswin, :x64_mingw, :jruby]