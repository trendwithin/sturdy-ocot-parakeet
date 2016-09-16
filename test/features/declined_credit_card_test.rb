require "test_helper"

feature "DeclinedCreditCard" do
  before :each do
    FakeStripe.stub_stripe
    @user = User.create(email: 'test@example.com', password: 'password')
    @user.confirm
    capybara_sign_in @user
  end

  scenario 'Invalid Credit Card', js: true do
    fill_in 'Card Number', with: 4242
    click_button 'Submit Payment'
    page.must_have_content 'The card number is not a valid credit card number.'
  end

  scenario 'Invalid Expiration', js: true do
    fill_in 'exp_month', with: 00
    fill_in 'exp_year', with: 20
    click_button 'Submit Payment'
    page.must_have_content "Your card's expiration month is invalid."
    fill_in 'exp_month', with: 12
    fill_in 'exp_year', with: 02
    click_button 'Submit Payment'
    page.must_have_content "Your card's expiration year is invalid."
  end

  scenario 'Invalid CVC', js: true do
    fill_in 'CVC', with: ''
    click_button 'Submit Payment'
    page.must_have_content "Your card's security code is invalid"
  end
end
