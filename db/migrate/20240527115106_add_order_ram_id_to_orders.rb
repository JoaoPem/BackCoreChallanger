class AddOrderRamIdToOrders < ActiveRecord::Migration[5.2]
  def change
    add_reference :orders, :order_ram, foreign_key: true
  end
end
