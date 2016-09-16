require "test_helper"

feature "User Inputs Valid Credit Card" do
  scenario "Stripe Accepts Card", js: true do
    FakeStripe.stub_stripe
    visit root_path
    page.must_have_content "Subscribe"
    click_link "Subscribe"
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    assert_difference 'User.count', 1 do
      click_button 'Sign up'
      mail = ActionMailer::Base.deliveries[0]
      token = mail.body.decoded.match(/confirmation_token=([^"]+)/)[1]
      assert_equal User.find_by(email: "test@example.com").confirmation_token, token
      visit "users/confirmation?confirmation_token=#{token}"
      page.must_have_text "Your email address has been successfully confirmed."
      page.must_have_text 'Your email address has been successfully confirmed. Please log in to with your new account to complete subscription.'
      assert_equal page.current_path, new_user_session_path
    end
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    page.must_have_text 'Signed in successfully.'
    fill_in 'Card Number', with: '4242 4242 4242 4242'
    fill_in 'exp_month', with: 12
    fill_in 'exp_year', with: 20
    fill_in 'CVC', with: 107
    click_button 'Submit Payment'
    page.must_have_text "What's in the Box?"
  end
end
