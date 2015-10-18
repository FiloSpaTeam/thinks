class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :title
      t.text :description

      t.belongs_to :project, index: true
      t.belongs_to :thinker, index: true

      t.timestamps null: false
    end
  end
end
