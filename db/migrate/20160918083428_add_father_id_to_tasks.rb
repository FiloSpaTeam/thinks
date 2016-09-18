class AddFatherIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :father_id, :integer
  end
end
