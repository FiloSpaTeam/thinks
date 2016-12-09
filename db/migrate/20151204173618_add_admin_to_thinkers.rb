class AddAdminToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :admin, :boolean, default: false
  end
end
