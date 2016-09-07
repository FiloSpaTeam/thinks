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

class Contribution < ActiveRecord::Base
  belongs_to :project, -> { with_deleted }
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
