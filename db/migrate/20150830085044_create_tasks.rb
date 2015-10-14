class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :serial
      t.string :description
      t.integer :project_id
      t.integer :thinker_id
      t.integer :worker_thinker_id
      t.integer :status_id
      t.integer :workload_id

      t.timestamps null: false
    end
  end
end
