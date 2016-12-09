class NotificationsThinkers < ActiveRecord::Migration
  def change
    create_table :notifications_thinkers, id: false do |t|
      t.belongs_to :notification, index: true
      t.belongs_to :thinker, index: true
    end
  end
end
