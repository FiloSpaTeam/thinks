class CreateCycles < ActiveRecord::Migration
  def change
    create_table :cycles do |t|
      t.string :translation_code
      t.string :description
      t.integer :days

      t.timestamps null: false
    end
  end
end
