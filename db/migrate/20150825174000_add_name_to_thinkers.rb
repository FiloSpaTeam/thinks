class AddNameToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :name, :string
  end
end
