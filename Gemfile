source 'http://rubygems.org'

# Bundle edge Rails instead:
gem 'rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', :git => 'git://github.com/rails/coffee-rails.git'
  gem 'uglifier'
  gem 'stylus'
end

gem 'jquery-rails'
gem 'thin'
gem 'nestful', :git => 'git://github.com/maccman/nestful.git'
gem 'omniauth'
gem 'rdiscount'

group :development do
  gem 'sqlite3'
  gem 'heroku'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  gem 'pg'
end