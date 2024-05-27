class CreateOrderRams < ActiveRecord::Migration[5.2]
  def change
    create_table :order_rams do |t|
      t.references :order, null: false, foreign_key: true
      t.text :ram_ids, array: true, default: []

      t.timestamps
    end
  end
end
