class AddDeletedAtToGoals < ActiveRecord::Migration
  def change
    add_column :goals, :deleted_at, :datetime
    add_index :goals, :deleted_at
  end
end
