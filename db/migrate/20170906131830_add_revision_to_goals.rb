class AddRevisionToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :revision, :integer, default: 0
  end
end
