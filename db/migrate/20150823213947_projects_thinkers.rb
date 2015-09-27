class ProjectsThinkers < ActiveRecord::Migration
  def change
    create_table :projects_thinkers, id: false do |t|
      t.belongs_to :project, index: true
      t.belongs_to :thinker, index: true
    end
  end
end
