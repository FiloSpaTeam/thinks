class CreateTeamRoles < ActiveRecord::Migration
  def change
    create_table :team_roles do |t|
      t.string :t_name

      t.timestamps null: false
    end
  end
end
