class AddVersionToReleases < ActiveRecord::Migration
  def change
    add_column :releases, :version, :string
  end
end
