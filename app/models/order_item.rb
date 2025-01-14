class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  # Validations
  validates :quantity, presence: true
  validates :price, presence: true
end
