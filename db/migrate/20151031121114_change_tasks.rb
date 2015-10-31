class ChangeTasks < ActiveRecord::Migration
  def change
    remove_column :tasks, :workload_id, :integer

    add_column :tasks, :workload, :float
    add_column :tasks, :variance, :float
  end
end
