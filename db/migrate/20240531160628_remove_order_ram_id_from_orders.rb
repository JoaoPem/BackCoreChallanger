class RemoveOrderRamIdFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :order_ram_id, :integer
  end
end
