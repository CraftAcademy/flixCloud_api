class Api::SubscriptionsController < ApplicationController
  # STRIPE_URL = "https://api.stripe.com/v1/customers"
  before_action :authenticate_user!

  def create
    # payment_status = perform_payment
    current_user.update_attribute(:subscriber, true)
    render json: { message: "Thank you for your payment, you are now a subscriber!"}

  end

  private

  def perform_payment
    customer = Stripe::Customer.create(
      email: current_user.email,
      source: params[:stripeToken],
      description: "Subscription for flixcloud"
    )
    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: 100,
      currency: 'sek'
    )

    charge
    
  end
end
