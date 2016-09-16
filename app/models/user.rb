class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


    def retrieve_or_create_stripe_customer
      if self.stripe_id?
        Stripe::Customer.retrieve(self.stripe_id)
      else
        Stripe::Customer.create(email: self.email)
      end
    end
end
