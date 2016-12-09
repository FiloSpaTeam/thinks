class AddIdToAssignedRoles < ActiveRecord::Migration
  def self.up
    add_column :assigned_roles, :id, :primary_key
  end

  def self.down
    remove_column :assigned_roles, :id
  end
end
