class AddUpdaterToTasks < ActiveRecord::Migration
  def up
    add_column :tasks, :who_updated_id, :integer

    Task.update_all('who_updated_id=thinker_id')
  end

  def down
    remove_column :tasks, :who_updated_id
  end
end
