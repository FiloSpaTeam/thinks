class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :t_name
      t.text :t_description

      t.timestamps null: false
    end
  end
end
