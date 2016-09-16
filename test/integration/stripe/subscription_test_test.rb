require 'test_helper'
require 'stripe_mock'

class SubscriptionTest < ActionDispatch::IntegrationTest
  def stripe_helper
    StripeMock.create_test_helper
    #code
  end

  def setup
    StripeMock.start
  end

  def teardown
    StripeMock.stop
  end

  test 'creates a stripe customer' do
    customer = Stripe::Customer.create({ email: 'stripe_test@example.com', card: stripe_helper.generate_card_token })
    assert_equal customer.email, 'stripe_test@example.com'
  end

  test 'declined card error' do
    StripeMock.prepare_card_error(:card_declined)
    err = assert_raises(Stripe::CardError) {
      Stripe::Charge.create(amount: 1, currency: 'usd')
    }
    assert_equal 'The card was declined', err.message
    assert_equal 402, err.http_status
  end
end
