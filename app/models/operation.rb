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

class Operation < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :task

  before_create :generate_serial

  def destroy_and_update_serial
    ActiveRecord::Base.transaction do
      begin
        task
          .operations
          .where('serial > ?', serial)
          .update_all('serial = serial - 1')

        really_destroy!
      rescue => ex
        puts ex.message
      end
    end
  end

  private

  def generate_serial
    operations_count = Operation.where(task_id: task.id).count + 1

    self.serial = operations_count
  end
end
