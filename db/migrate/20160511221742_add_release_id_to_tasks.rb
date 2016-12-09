class AddReleaseIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :release_id, :integer
  end
end
