class AddReleaseToGoals < ActiveRecord::Migration
  def change
    add_reference :goals, :release, index: true, foreign_key: true
  end
end
