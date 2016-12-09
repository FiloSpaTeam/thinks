# This file is part of Thinks.

# Thinks is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Thinks is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero Public License for more details.

# You should have received a copy of the GNU Affero Public License
# along with Thinks.  If not, see <http://www.gnu.org/licenses/>.

# Copyright (c) 2015, Claudio Maradonna

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
