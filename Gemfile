source "https://rubygems.org"

gem "rails", "~> 8.0.1"
gem "propshaft"
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "pagy"
gem "ransack"
gem "spreadsheet_architect"
# gem "jbuilder"
# gem "kamal", require: false
# gem "thruster", require: false
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "pry-rails", "~> 0.3.11"
  gem "awesome_print", "~> 1.9"
  gem "rails_live_reload", "~> 0.3.6"
  gem "administration-zero", path: "./vendor/gems/administration-zero"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

