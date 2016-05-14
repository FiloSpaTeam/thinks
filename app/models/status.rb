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

class Status < ActiveRecord::Base
  has_many :tasks

  default_scope { order(:progress_order) }

  scope :backlog, lambda { where translation_code: :backlog }
  scope :done, lambda { where translation_code: :done }
  scope :release, lambda { where translation_code: :release }
  scope :sprint, lambda { where translation_code: :sprint }
  scope :in_progress, lambda { where translation_code: :in_progress }
end
