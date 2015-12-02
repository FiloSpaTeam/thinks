class RemoveColumnsTitleAndDescriptionToSprints < ActiveRecord::Migration
  def up
    remove_column :sprints, :title
    remove_column :sprints, :description
  end

  def down
    add_column :sprints, :title, :string
    add_column :sprints, :description, :text
  end
end
