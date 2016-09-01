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

    # Confirmable
    assert_equal nil, user.confirmed_at
    mail = ActionMailer::Base.deliveries[0]
    token = mail.body.decoded.match(/confirmation_token=([^"]+)/)[1]
    assert_equal true, mail.to_s.include?('From: no-reply@example.com')
    get "/users/confirmation?confirmation_token=#{token}"
    notice = 'Your email address has been successfully confirmed. Please log in to with' +
             ' your new account to complete subscription.'
    assert_equal notice, flash[:notice]
    user.reload
    assert user.confirmed_at.to_date == Date.today
  end

  test 'Confirmed User Subscribes' do
    user = User.create!(email: 'confirmed@example.com', password: 'password')
    confirmation_token = user.confirmation_token
    get "/users/confirmation?confirmation_token=#{confirmation_token}"
    follow_redirect!
    assert_template 'devise/sessions/new'
    user.reload
    sign_in user
    follow_redirect!
    assert_template 'subscriptions/new'
  end
end
