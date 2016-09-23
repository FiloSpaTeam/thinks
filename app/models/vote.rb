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

class Vote < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :thinker
  belongs_to :task
  belongs_to :workload

  after_save :save_vote_and_update_task

  private

  def save_vote_and_update_task
    # update average workload and standard_deviation
    average = task.average

    # search for the closest workload
    task.workload           = Workload.closest(average)
    task.standard_deviation = task.standard_deviation

    task.save
  end
end
