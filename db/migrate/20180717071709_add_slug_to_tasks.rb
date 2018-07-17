class AddSlugToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :slug, :string
    add_index :tasks, :slug, unique: true

    Task.find_each(&:save)
  end
end
