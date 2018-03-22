source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Mongo
gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'
gem 'mongoid-history'

# kaminari
gem 'kaminari-mongoid'
gem 'api-pagination'

# Grape
gem 'grape'
gem 'grape-entity'
gem 'grape_on_rails_routes'
gem 'grape-swagger'
gem 'grape-swagger-entity'

# rack
gem 'rack-cors'

# json
gem 'json'

# puma
gem 'puma'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# JWT
gem 'jwt'

# env
gem 'dotenv-rails'

# rspec
gem 'rspec-rails'

# sidekiq
gem 'sidekiq'
gem 'sidekiq-cron', '~> 0.6.3'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # byebug
  gem 'byebug'

  # factory_girl
  gem 'factory_girl_rails', '~> 4.5', require: false
end

group :production do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

