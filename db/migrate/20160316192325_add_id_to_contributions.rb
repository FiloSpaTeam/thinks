class AddIdToContributions < ActiveRecord::Migration
  def self.up
    add_column :contributions, :id, :primary_key
  end

  def self.down
    remove_column :contributions, :id
  end
end
