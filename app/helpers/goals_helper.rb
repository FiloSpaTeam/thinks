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

module GoalsHelper
  def tasks_title(goal)
    pluralize(goal.tasks.count, 'task') + ", " +
      pluralize(goal.tasks.done.count, 'task') + " done, " +
      pluralize(goal.tasks.in_progress.count, 'task') + " in progress"
  end

  def release_btn_title(tasks_ready)
    "Put " + pluralize(tasks_ready.count, 'task') + " in Sprint automatically"
  end
end
