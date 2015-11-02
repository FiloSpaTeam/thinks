class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.belongs_to :comment
      t.belongs_to :thinker
    end
  end
end
