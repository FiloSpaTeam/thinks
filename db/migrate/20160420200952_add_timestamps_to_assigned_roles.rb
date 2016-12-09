class AddTimestampsToAssignedRoles < ActiveRecord::Migration
  def change
    add_column(:assigned_roles, :created_at, :datetime)
    add_column(:assigned_roles, :updated_at, :datetime)
  end
end
