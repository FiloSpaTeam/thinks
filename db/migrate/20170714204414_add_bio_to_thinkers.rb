class AddBioToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :bio, :string
  end
end
