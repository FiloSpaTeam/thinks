class RenameColumnReasons < ActiveRecord::Migration
  def self.up
    rename_column :reasons, :comment_id, :related_id

    Reason.update_all(related_type: :Comment)
  end

  def self.down
    rename_column :reasons, :related_id, :comment_id
  end
end
