class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.belongs_to :thinker
      t.belongs_to :task
      t.integer :value

      t.timestamps null: false
    end
  end
end
