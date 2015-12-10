class AddSerialToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :serial, :integer
  end
end
