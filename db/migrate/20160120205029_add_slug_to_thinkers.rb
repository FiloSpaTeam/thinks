class AddSlugToThinkers < ActiveRecord::Migration
  def change
    add_column :thinkers, :slug, :string
    add_index :thinkers, :slug, unique: true

    Thinker.find_each(&:save)
  end
end
