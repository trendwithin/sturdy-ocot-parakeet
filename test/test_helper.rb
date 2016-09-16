require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rg'
require "minitest/rails/capybara"
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# Refer to https://github.com/plataformatec/devise/issues/3913
class ActionDispatch::IntegrationTest
  def sign_in user
    post user_session_path \
    "user[email]" => user.email,
    "user[password]" => user.password || 'password'
  end
end

def capybara_sign_in user
  visit new_user_session_path
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'password'
  click_button 'Log in'
end

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('<STRIPE_API_KEY') { ENV['stripe_api_key'] }
  config.filter_sensitive_data('<STRIPE_PUBLISHABLE_KEY') { ENV['stripe_publishable_key'] }
  config.ignore_hosts 'codeclimate.com'
end

class Capybara::Rails::TestCase
  self.use_transactional_tests = false

  before do
    if metadata[:js]
      Capybara.current_driver = Capybara.javascript_driver
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
    end
  end

  after do
    if metadata[:js]
      DatabaseCleaner.clean
    end

    Capybara.reset_sessions!
    Capybara.current_driver = Capybara.default_driver
  end
end
