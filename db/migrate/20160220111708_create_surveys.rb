class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :t_title

      t.timestamps null: false
    end
  end
end
