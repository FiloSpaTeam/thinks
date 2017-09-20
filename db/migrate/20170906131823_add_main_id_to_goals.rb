class AddMainIdToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :main_id, :integer, default: 0
  end
end
