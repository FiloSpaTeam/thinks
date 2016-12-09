class LanguagesProjects < ActiveRecord::Migration
  def change
    create_table :languages_projects, id: false do |t|
      t.belongs_to :language, index: true
      t.belongs_to :project, index: true
    end
  end
end
