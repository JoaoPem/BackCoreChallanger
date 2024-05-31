class OrderRam < ApplicationRecord
  # Associação N para N com Order através da tabela intermediária OrderOrderRam
  has_many :order_order_rams, dependent: :destroy
  has_many :orders, through: :order_order_rams

  # Método que retorna os produtos de RAM associados a esta OrderRam
  def rams
    Product.where(id: ram_ids)
  end
end
