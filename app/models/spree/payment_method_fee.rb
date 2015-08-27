class Spree::PaymentMethodFee < ActiveRecord::Base
  belongs_to :payment_method, class_name: 'Spree::PaymentMethod'

  attr_accessible :amount, :currency, :payment_method_id

  validates :currency, uniqueness: {scope: :payment_method_id}

  def add_adjustment_to_order(order)
    order.destroy_fee_adjustments_for_order

    adjustment = order.adjustments.new
    adjustment.source = order
    adjustment.amount = self.amount
    adjustment.label = 'fee'
    adjustment.mandatory = true
    adjustment.eligible = true

    adjustment.save!
  end
end
