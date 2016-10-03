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

class NotificationsPreference < ActiveRecord::Base
  enum sending_types: [:only_web, :only_email, :web_and_email]

  # Consideration level:
  # - one: all notifications are sent
  # - two: no notifications about something where i've not contributed (example, voted tasks)
  # - three: only notifications about my personal work (tasks created...)
  # - four: only notifications about progress
  # - five: no consideration
  enum minimum_considerations_for_sending: [:one, :two, :three, :four, :five]

  belongs_to :thinker
end
