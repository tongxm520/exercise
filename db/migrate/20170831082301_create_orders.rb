class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :street
      t.string :town
      t.string :pay_type
      t.string :zip
      t.string :phone
      t.integer :customer_id

      t.timestamps
    end
  end
end
