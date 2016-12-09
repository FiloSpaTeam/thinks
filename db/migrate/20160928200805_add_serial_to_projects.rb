class AddSerialToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :serial, :string
  end
end
