class OrderOrderRam < ApplicationRecord
  belongs_to :order
  belongs_to :order_ram
  # Garante que a combinação de order_id e order_ram_id seja única.
  validates :order_id, uniqueness: { scope: :order_ram_id }
end
