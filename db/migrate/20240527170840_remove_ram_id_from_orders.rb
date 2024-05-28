class RemoveRamIdFromOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :ram_id, :integer
  end
end
