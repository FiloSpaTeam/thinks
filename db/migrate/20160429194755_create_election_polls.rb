class CreateElectionPolls < ActiveRecord::Migration
  def change
    create_table :election_polls do |t|
      t.integer :status, default: 0
      t.belongs_to :project, index: true
      t.belongs_to :team_role, index: true

      t.timestamps null: false
    end
  end
end
