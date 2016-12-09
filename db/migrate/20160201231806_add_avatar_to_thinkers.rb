class AddAvatarToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :avatar, :string
  end
end
