class AddColumnEndAtToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :end_at, :datetime
    add_index :tasks, :end_at
  end
end
