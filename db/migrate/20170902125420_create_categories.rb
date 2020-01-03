class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name,null: false
      t.integer :parent_id,null: false
      t.integer :position
      t.string :ancestor,null: false

      t.timestamps
    end
  end
end
