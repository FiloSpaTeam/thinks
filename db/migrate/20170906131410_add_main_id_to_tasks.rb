class AddMainIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :main_id, :integer, default: 0
  end
end
