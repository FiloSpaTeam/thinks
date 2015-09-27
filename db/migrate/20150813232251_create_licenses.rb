class CreateLicenses < ActiveRecord::Migration
  def change
    create_table :licenses do |t|
      t.string :name, limit: 50
      t.string :description, limit: 1600
      t.string :url

      t.timestamps null: false
    end
  end
end
