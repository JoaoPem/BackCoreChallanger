class OrderRam < ApplicationRecord
  belongs_to :order

  def rams
    Product.where(id: ram_ids)
  end
end