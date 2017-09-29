class AddAdminToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :admin, :boolean, :default=>false
  end
end

