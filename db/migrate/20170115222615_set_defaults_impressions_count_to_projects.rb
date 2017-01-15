class SetDefaultsImpressionsCountToProjects < ActiveRecord::Migration
  def self.up
    change_column :projects, :impressions_count, :integer, default: 0
  end

  def self.down
    # You can't currently remove default values in Rails
    raise ActiveRecord::IrreversibleMigration, "Can't remove the default"
  end
end
