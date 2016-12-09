class SetEndAtLikeUpdatedAtToTasks < ActiveRecord::Migration
  def self.up
    Task.update_all('end_at=updated_at')
  end

  def self.down
  end
end
