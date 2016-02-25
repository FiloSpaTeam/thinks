class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :t_description
      t.integer :survey_id

      t.timestamps null: false
    end
  end
end
