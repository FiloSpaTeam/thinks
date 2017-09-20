class AddRevisionToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :revision, :integer, default: 0
  end
end
