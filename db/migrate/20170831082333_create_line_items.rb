class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :product_id, null: false
      t.integer :cart_id
      t.integer :quantity, default: 1
      t.integer :order_id

      t.timestamps
    end
  end
end
