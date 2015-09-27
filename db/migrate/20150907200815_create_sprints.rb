class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :title
      t.string :description
      t.integer :goal
      t.integer :obtained
      t.integer :project_id

      t.timestamps null: false
    end
  end
end
