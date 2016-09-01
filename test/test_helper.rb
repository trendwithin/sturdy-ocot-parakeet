require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rg'

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
