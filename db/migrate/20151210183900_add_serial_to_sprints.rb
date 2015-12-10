class AddSerialToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :serial, :string
  end
end
