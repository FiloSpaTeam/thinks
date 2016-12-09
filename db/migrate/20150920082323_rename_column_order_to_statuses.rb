class RenameColumnOrderToStatuses < ActiveRecord::Migration
  def change
    rename_column :statuses, :order, :progress_order
  end
end
