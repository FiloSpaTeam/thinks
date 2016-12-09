class CreateWorkloads < ActiveRecord::Migration
  def change
    create_table :workloads do |t|
      t.float :value

      t.timestamps null: false
    end
  end
end
