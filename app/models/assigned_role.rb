class AssignedRole < ActiveRecord::Base
  belongs_to :team_role
  belongs_to :thinker
  belongs_to :project
end
