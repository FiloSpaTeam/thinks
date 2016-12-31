class AddImpressionsCountToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :impressions_count, :integer
  end
end
