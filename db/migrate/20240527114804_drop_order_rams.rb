class DropOrderRams < ActiveRecord::Migration[5.2]
  def change
    if table_exists?(:order_rams)
      drop_table :order_rams
    end
  end
end
