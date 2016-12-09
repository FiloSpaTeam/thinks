class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :text
      t.boolean :approved

      t.belongs_to :task, index: true
      t.belongs_to :thinker, index: true

      t.timestamps null: false
    end
  end
end
