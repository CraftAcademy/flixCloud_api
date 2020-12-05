class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    payment_status = perform_payment

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
