class AddColumnDescriptionToWorkloads < ActiveRecord::Migration
  def change
    add_column :workloads, :description, :string
  end
end
