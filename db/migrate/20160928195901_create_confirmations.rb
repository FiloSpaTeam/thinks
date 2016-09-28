class CreateConfirmations < ActiveRecord::Migration
  def change
    create_table :confirmations do |t|
      t.belongs_to :project, index: true

      t.boolean :status

      t.timestamps null: false
    end
  end
end
