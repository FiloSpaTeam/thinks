class CreateAssignedRoles < ActiveRecord::Migration
  def change
    create_table :assigned_roles, id: false do |t|
      t.belongs_to :thinker, index: true
      t.belongs_to :team_role, index: true
      t.belongs_to :project, index: true
    end
  end
end
