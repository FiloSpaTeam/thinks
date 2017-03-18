class AddMottoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :motto, :string
  end
end
