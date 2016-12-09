class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :project
      t.belongs_to :thinker
      t.belongs_to :sprint
      t.belongs_to :goal
      t.belongs_to :task

      t.string :controller
      t.string :action

      t.timestamps null: false
    end
  end
end
