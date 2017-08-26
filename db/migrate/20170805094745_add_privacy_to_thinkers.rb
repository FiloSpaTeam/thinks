class AddPrivacyToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :privacy, :integer, default: 0
  end
end
