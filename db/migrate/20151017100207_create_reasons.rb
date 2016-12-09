class CreateReasons < ActiveRecord::Migration
  def change
    create_table :reasons do |t|
      t.text :text

      t.belongs_to :comment, index: true
      t.belongs_to :thinker, index: true

      t.timestamps null: false
    end
  end
end
