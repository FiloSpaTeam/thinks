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

class Notification < ActiveRecord::Base
  acts_as_paranoid

  filterrific(
    default_filter_params: { },
    available_filters: [
      :sorted_by
    ]
  )

  belongs_to :thinker
  belongs_to :sprint
  belongs_to :project, -> { with_deleted }
  belongs_to :goal
  belongs_to :task, -> { with_deleted }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title_/
      # Simple sort on the name colums
      order("LOWER(projects.title) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.user(thinker)
    where.not(thinker: thinker)
         .where(project: thinker.contributions
              .where('intensity > ?', Contribution.intensities[:nothing]).pluck(:project_id))
         .where.not(id: thinker.notifications.pluck(:id))
  end
end
