class RenameVarianceToStandardDeviationInTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :variance, :standard_deviation
  end
end
