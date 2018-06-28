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

class Goal < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :project
  belongs_to :thinker
  belongs_to :main, class_name: 'Goal', foreign_key: 'main_id'

  has_many :tasks
  has_many :revisions, class_name: 'Goal', foreign_key: 'main_id', dependent: :destroy

  validates :title, length: { maximum: 60 }, presence: true
  validates :description, length: { minimum: 30 }, presence: true

  validates_numericality_of :progress, greater_than_or_equal_to: 0
  validates_numericality_of :progress, less_than_or_equal_to: 100

  scope :search_title, lambda { |title|
    where('title LIKE ?', "%#{title}%")
  }

  scope :search_title_and_description, lambda { |query|
    where("lower(title) LIKE '%#{query.downcase.strip}%' OR lower(description) LIKE '%#{query.downcase.strip}%'")
  }

  scope :search_task, lambda { |title|
    joins(:tasks).where('tasks.title LIKE ?', "%#{title}%").distinct
  }

  scope :with_task, lambda { |task|
    where([
            %(
            EXISTS (
                SELECT 1
                FROM tasks
                WHERE goals.id = tasks.goal_id
                AND tasks.id = ?)
            ),
            task
          ])
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title_/
      # Simple sort on the name colums
      order("LOWER(goals.title) #{ direction }")
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :progress_lower_than, lambda { |value|
    where('progress < ?', value)
  }

  def progress_percentage
    0 if tasks.empty? || tasks.nil?

    tasks_done = tasks.where(status_id: Status.done)

    total_tasks_number      = tasks.count
    total_tasks_done_number = tasks_done.count

    @progress_percentage = total_tasks_done_number * 100 / (total_tasks_number.nonzero? || 1)
  end

  def visible_text
    title
  end
end
