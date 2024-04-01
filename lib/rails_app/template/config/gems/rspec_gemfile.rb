group :development, :test do
  gem "rspec-rails", "~> 6.1.0"
  gem "factory_bot_rails"
end

group :development do
  gem "fuubar", "~> 2.5", ">= 2.5.1"
end

group :test do
  gem "capybara"
  gem "vcr"
  gem "webmock"
end