class CreateDependences < ActiveRecord::Migration
  def change
    create_table :dependences do |t|
      t.boolean :external, default: false
      t.string :url
      t.string :reason, limit: 1600
    
      t.belongs_to :project, index: true

      t.timestamps null: false
    end
  end
end
