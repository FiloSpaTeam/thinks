class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :t_name
      t.string :t_description

      t.timestamps null: false
    end
  end
end
