class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    customer = if current_user.stripe_id?
                 Stripe::Customer.retrieve(current_user.stripe_id)
               else
                 Stripe::Customer.create(email: current_user.email)
               end

    subscription = customer.subscriptions.create(
      source: params[:stripeToken],
      plan: 'monthly'
    )
    current_user.update(
      stripe_id: customer.id,
      stripe_subscription_id: subscription.id,
      card_last4: params[:card_last4],
      card_exp_month: params[:card_exp_month],
      card_exp_year: params[:card_exp_year],
      card_brand: params[:card_brand]
    )
    redirect_to root_url
  end

  def show
  end

  def destroy
  end
end
