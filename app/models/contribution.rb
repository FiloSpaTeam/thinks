class Contribution < ActiveRecord::Base
  belongs_to :project
  belongs_to :thinker

  enum intensity: [:nothing, :watching, :partecipate]

  def save_and_update_team_role
    ActiveRecord::Base.transaction do
      save

      if nothing?
        AssignedRole.where(project: project).where(thinker: thinker).delete_all
      else
        AssignedRole
          .where(project: project)
          .where(thinker: thinker).first_or_create do |team_role|
          team_role.team_role = TeamRole.team_member.first
        end
      end
    end
  end
end
