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

module ReleasesHelper
  def apply_filters(scope, params)
    scope = scope.search_title_and_description(params[:search_title_and_description]) if params.key?(:search_title_and_description) &&
                                                                                         params[:search_title_and_description].present?

    scope = scope.with_task(params[Enums::FiltersNames::TASK]) if
      params.key?(Enums::FiltersNames::TASK) &&
      params[Enums::FiltersNames::TASK].present?

    scope = scope.progress_lower_than(params[:progress_lower_than]) if params.key?(:progress_lower_than) &&
                                                                       params[:progress_lower_than].present?

    scope
  end
end
