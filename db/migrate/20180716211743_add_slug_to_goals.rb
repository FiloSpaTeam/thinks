class AddSlugToGoals < ActiveRecord::Migration[5.2]
  def change
    add_column :goals, :slug, :string
    add_index :goals, :slug, unique: true

    Goal.find_each(&:save)
  end
end
