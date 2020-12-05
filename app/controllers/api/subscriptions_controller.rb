class Api::SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    payment_status = perform_payment
    
    if payment_status
      current_user.update_attribute(:subscriber, true)
      render json: { message: "Thank you for your payment, you are now a subscriber!", paid: true}
    else
      render json: { message: "Something went wrong, please try again later"}, status: 422  
    end
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

    charge.paid
    
  end
end
