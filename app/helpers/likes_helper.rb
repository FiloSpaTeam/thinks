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

module LikesHelper
  def like_count(number)
    case number
    when 0..20 then number.to_s
    when 20..50 then '20+'
    when 50..100 then '50+'
    when 100..500 then '100+'
    when 500..1000 then '500+'
    when 1000..Float::INFINITY then '1000+'
    end
  end
end
