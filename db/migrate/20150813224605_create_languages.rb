class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name, limit: 25

      t.timestamps null: false
    end
  end
end
