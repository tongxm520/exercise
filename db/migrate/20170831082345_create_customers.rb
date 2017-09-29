class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :first_name,null: false
      t.string :last_name,null: false
      t.string :user_name,null: false
      t.string :hashed_password,null: false
      t.string :salt,null: false
      t.string :email,null: false

      t.timestamps
    end
  end
end
