class AddCountryToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :country_iso, :string
  end
end
