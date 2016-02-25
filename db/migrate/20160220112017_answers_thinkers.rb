class AnswersThinkers < ActiveRecord::Migration
  def change
    create_table :answers_thinkers, id: false do |t|
      t.belongs_to :answer, index: true
      t.belongs_to :thinker, index: true
      t.belongs_to :sprint, index: true
    end
  end
end
