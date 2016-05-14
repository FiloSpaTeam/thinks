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

class Workload < ActiveRecord::Base
  has_many :tasks, through: :votes

  default_scope { order(:value) }

  scope :infinity, -> { where value: 9999 }

  def self.closest(value)
    workloads = pluck(:value)

    workloads.min_by { |x| (x.to_f - value).abs }
  end
end
