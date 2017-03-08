class AddRecruitmentToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :recruitment, :boolean, default: false
  end
end
