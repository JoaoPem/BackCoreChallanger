class CreateOrderOrderRams < ActiveRecord::Migration[5.2]
  def change
    create_table :order_order_rams do |t|
      t.references :order, null: false, foreign_key: true
      t.references :order_ram, null: false, foreign_key: true

      t.timestamps
    end
  end
end
