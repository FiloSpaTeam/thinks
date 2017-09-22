class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.decimal :price, precision: 8, scale: 2
      t.string :module
      t.string :description

      t.timestamps null: true
    end
  end
end
