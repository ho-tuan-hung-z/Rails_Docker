class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  # Validations
  validates :status, presence: true
  validates :total_price, presence: true
end
