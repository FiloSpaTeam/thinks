class AddDeletedAtToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :deleted_at, :datetime
    add_index :sprints, :deleted_at
  end
end
