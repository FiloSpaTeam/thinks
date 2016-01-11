class AddColumnProgressToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :progress, :float

    goals = Goal.all
    goals.each do |goal|
      goal.progress = goal.progress_percentage

      goal.save
    end
  end
end
