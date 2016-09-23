class AddDeletedAtToOperations < ActiveRecord::Migration
  def change
    add_column :operations, :deleted_at, :datetime
    add_index :operations, :deleted_at
  end
end
