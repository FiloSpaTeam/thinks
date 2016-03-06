class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.integer :serial
      t.string :text
      t.boolean :done

      t.timestamps null: false
    end
  end
end
