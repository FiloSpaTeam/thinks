class CreateTableNotificationsPreferences < ActiveRecord::Migration
  def change
    create_table :notifications_preferences do |t|
      t.belongs_to :thinker, index: true

      t.integer :sending_type, default: 0
      t.integer :minimum_consideration_for_sending, default: 0

      t.timestamps null: false
    end
  end
end
