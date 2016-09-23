class AddIdToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :id, :primary_key
  end

  def self.down
    remove_column :votes, :id
  end
end
