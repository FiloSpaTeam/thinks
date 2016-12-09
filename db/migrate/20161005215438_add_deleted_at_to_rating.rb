class AddDeletedAtToRating < ActiveRecord::Migration
  def change
    add_column :ratings, :deleted_at, :datetime
    add_index :ratings, :deleted_at
  end
end
