class AddOrderToStatuses < ActiveRecord::Migration
  def change
    add_column :statuses, :order, :integer
  end
end
