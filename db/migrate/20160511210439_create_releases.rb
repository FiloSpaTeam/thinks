class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.belongs_to :project, index: true

      t.string :title, limit: 60
      t.string :description, limit: 1600
      t.date :end_at

      t.float :progress

      t.timestamps null: false
    end
  end
end
