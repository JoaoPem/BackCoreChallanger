class RemoveOrderIdFromOrderRams < ActiveRecord::Migration[5.2]
  def change
    remove_column :order_rams, :order_id, :integer
  end
end
