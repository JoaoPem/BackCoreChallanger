class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :processor, foreign_key: { to_table: :products }
      t.references :motherboard, foreign_key: { to_table: :products }
      t.references :ram, foreign_key: { to_table: :products }
      t.references :video_card, foreign_key: { to_table: :products }

      t.timestamps
    end
  end
end
