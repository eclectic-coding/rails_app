gem "devise"

group :development, :test do
  gem "faker"
  gem "annotate"
end

group :development do
  gem "rubocop-rails-omakase", require: false
  gem "bundle-audit", require: false
  gem "brakeman", require: false
  gem "bullet"
  # gem "strong_migrations"
end

group :test do
  gem "simplecov", "~> 0.21.2", require: false
  gem "test-prof"
end
