class AddPrintOrderToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :print_order, :integer
  end
end
