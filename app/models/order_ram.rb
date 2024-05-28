class OrderRam < ApplicationRecord

  # Associação  com o modelo Order
  belongs_to :order

  # Método que retorna os produtos de RAM associados a esta OrderRam
  def rams
    Product.where(id: ram_ids)
  end
end