source 'https://rubygems.org'

#ruby '2.1.5'

#gem 'rails', '4.0.2'
gem 'pg'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'gon'
gem 'jquery-rails'
gem 'jbuilder', '~> 1.2'
gem 'bower-rails', '~> 0.7.3'
gem 'angular-rails-templates', '~> 0.1.3'
gem 'haml-rails', '~> 0.5.3'
gem 'normalize-rails', '~> 3.0.1'
gem 'devise', '~> 3.2.4'
gem 'instagram', '~> 1.1.2'
gem 'rack-cors', :require => 'rack/cors'
gem 'redis'
gem 'state_machine', '~> 1.2.0'
gem 'httparty', '~> 0.13.1'
gem 'figaro'
gem 'whenever', :require => false
gem 'konf', '~> 0.0.2'
gem 'active_model_serializers', '~> 0.9.0'
gem 'font-awesome-rails'
gem 'puma'

group :development do
  gem 'quiet_assets'
  gem 'letter_opener', '~> 1.2.0'
end

group :test do
  gem 'faker', '~> 1.4.2'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'webmock', '~> 1.20.4'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.2'
  gem 'rspec-collection_matchers', '~> 1.0.0'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'capybara', '~> 2.4.1'
  gem 'pry'
  gem 'pry-nav'
  gem 'climate_control', '~> 0.0.3'
end
gem 'rvm-capistrano'
group :development, :deployment,:production do
  gem 'capistrano', '~> 3.0'
  gem 'capistrano-rbenv'
  gem 'capistrano-rvm'
  #gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-slackbot'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq'
  gem 'capistrano-postgresql'
end

gem 'rails_12factor', group: :production
