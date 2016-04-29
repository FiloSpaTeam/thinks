class CreateVoters < ActiveRecord::Migration
  def change
    create_table :voters do |t|
      t.belongs_to :election_poll, index: true
      t.belongs_to :thinker, index: true
      t.integer :elect_id

      t.timestamps null: false
    end
  end
end
