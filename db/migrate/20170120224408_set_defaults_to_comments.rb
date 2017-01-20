class SetDefaultsToComments < ActiveRecord::Migration
  def self.up
    change_column :comments, :approved, :boolean, default: false, null: false
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
