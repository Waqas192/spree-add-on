source 'http://rubygems.org'

# Provides basic authentication functionality for testing parts of your engine
gem "spree_auth_devise", "~> 3.1.0"

# we use line_item_description_text which is in newer sprees
gem "spree", "~> 3.1.0"

group :development, :test do
  gem "fuubar"
  gem "pry"
end

group :test do
  gem "shoulda-matchers"
  gem "rspec-activemodel-mocks"
  gem "rspec-its"
end

gemspec
