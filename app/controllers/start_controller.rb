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

class StartController < ApplicationController
  def index
    @steps = [
      { step: 1, title: '.step_1', description: '.step_description_1' },
      { step: 2, title: '.step_2', description: '.step_description_2' },
      { step: 3, title: '.step_3', description: '.step_description_3' },
      { step: 4, title: '.step_4', description: '.step_description_4' }
    ]

    @offers = Offer.order(:price).all
  end
end
