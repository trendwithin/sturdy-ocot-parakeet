require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'Confirmable User After Sign up' do
    get new_user_registration_path
    assert_response :success
    assert_difference 'User.count', 1 do
      post user_registration_path, params: { user: { email: 'signuptest@example.com', password: 'password' } }
    end

    user = assigns(:user)
    follow_redirect!
    notice = 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal 'processing_payment', user.role
    assert_equal notice, flash[:notice]
  end
end
