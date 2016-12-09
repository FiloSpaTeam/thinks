class AddThinkerIdToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :thinker_id, :integer
  end
end
