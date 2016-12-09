class CreateBannedThinker < ActiveRecord::Migration
  def change
    create_table :banned_thinkers do |t|
      t.belongs_to :project
      t.belongs_to :thinker

      t.string :reason, limit: 160
    end
  end
end
