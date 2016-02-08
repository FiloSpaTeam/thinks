class CreateCountries < ActiveRecord::Migration
  def up
    create_table :countries, id: false do |t|
      t.string :iso
      t.string :name, null: false
      t.string :printable_name, null: false
      t.string :iso3
      t.integer :numcode
    end

    execute 'ALTER TABLE countries ADD PRIMARY KEY (iso);'
  end

  def down
    drop_table :countries
  end
end
