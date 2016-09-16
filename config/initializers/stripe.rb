require 'stripe'
Stripe.api_key = ENV['stripe_api_key']

unless defined? STRIPE_JS_HOST
  STRIPE_JS_HOST = 'https://js.stripe.com'
end
