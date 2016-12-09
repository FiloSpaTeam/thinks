class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, limit: 60
      t.string :description, limit: 1600
      t.integer :minimum_team_number, default: 2
      t.date :release_at
      t.string :home_url
      t.string :source_code_url
      t.string :documentation_url

      t.belongs_to :license, index: true

      t.timestamps null: false
    end
  end
end
