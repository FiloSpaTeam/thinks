class AssignedRole < ActiveRecord::Base
  paginates_per 10
  max_paginates_per 50

  filterrific(
    available_filters: [
      :with_role
    ]
  )

  belongs_to :team_role
  belongs_to :thinker
  belongs_to :project

  scope :with_role, ->(role) { where(team_role: role) }
  scope :with_project, ->(project) { where(project: project) }

  def delete_with_contribution
    ActiveRecord::Base.transaction do
      destroy

      Contribution
        .where(project: project)
        .where(thinker: thinker)
        .update_all(intensity: Contribution.intensities[:nothing])
    end
  end
end
