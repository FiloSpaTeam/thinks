class TasksWorkloads < ActiveRecord::Migration
  def change
    create_table :tasks_workloads do |t|
      t.belongs_to :task, index: true
      t.belongs_to :thinker, index: true
      t.belongs_to :workload, index: true
    end
  end
end
