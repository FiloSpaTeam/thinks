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

class Task < ActiveRecord::Base
  acts_as_paranoid

  extend FriendlyId
  friendly_id :title, use: :slugged

  is_impressionable counter_cache: true

  has_many :votes
  has_many :workloads, through: :votes
  has_many :comments, dependent: :destroy
  has_many :operations, dependent: :destroy
  has_many :likes, through: :comments
  has_many :children, class_name: 'Task', foreign_key: 'father_id'
  has_many :revisions, class_name: 'Task', foreign_key: 'main_id', dependent: :destroy
  has_many :ratings, dependent: :destroy

  has_many :notifications, -> { where(model: :Task) }, foreign_key: :model_id, dependent: :destroy

  has_one :reason, as: :related, dependent: :destroy

  belongs_to :project
  belongs_to :goal
  belongs_to :thinker
  belongs_to :worker, class_name: 'Thinker', foreign_key: 'worker_thinker_id'
  belongs_to :updater, class_name: 'Thinker', foreign_key: 'who_updated_id'
  belongs_to :father, class_name: 'Task', foreign_key: 'father_id'
  belongs_to :main, class_name: 'Task', foreign_key: 'main_id'
  belongs_to :status

  before_create :generate_serial
  before_validation :default_values

  after_save :update_goal_and_release, :update_project_condition

  validates :title, length: { maximum: 60 }, presence: true
  validates :description, length: { minimum: 30 }
  validates :project_id, presence: true, on: :create
  validates :status_id, presence: true, on: :create
  validates :thinker_id, presence: true, on: :create

  scope :status_progress, ->(status) { where status: status }
  scope :in_progress, -> { where status: Status.in_progress }
  scope :done, -> { where status: Status.done }
  scope :release, -> { where status: Status.release }
  scope :in_sprint, -> { where status: Status.sprint }

  scope :ready_to_sprint, lambda {
    where('standard_deviation < ?', 3).where(status: Status.release)
  }

  scope :workload_lower_than, lambda { |value|
    subquery = unscoped
               .select('AVG(workloads.value) as average, tasks.id')
               .joins(:workloads)
               .group('tasks.id')

    unscoped
      .select('t.average, tasks.*')
      .from("(#{subquery.to_sql}) t")
      .joins('INNER JOIN tasks on t.id = tasks.id ')
      .where('t.average < ?', value)
  }

  scope :with_goal, lambda { |goal|
    where(goal: goal)
  }

  scope :with_worker, lambda { |worker|
    where(worker: Thinker.friendly.find(worker))
  }

  scope :with_thinker, lambda { |thinker|
    where(thinker: Thinker.friendly.find(thinker))
  }

  scope :with_project, lambda { |project|
    where(project: Project.friendly.find(project))
  }

  scope :with_sprint, lambda { |sprint_id|
    sprint = Sprint.find(sprint_id)

    if sprint.next.nil?
      where('updated_at >= ?', sprint.created_at)
    else
      where('updated_at >= ? and updated_at < ?', sprint.created_at, sprint.next.created_at)
    end
  }

  scope :with_deleted_at, lambda {
    only_deleted
  }

  scope :updated_at_in_sprint, lambda { |sprint|
    result = where('updated_at >= ?', sprint.created_at)

    return result if sprint.next.nil?

    result.where('updated_at < ?', sprint.next.created_at)
  }

  scope :search_title_and_description, lambda { |query|
    where("lower(title) LIKE '%#{query.downcase.strip}%' OR lower(description) LIKE '%#{query.downcase.strip}%'")
  }

  scope :search_goal, lambda { |title|
    joins(:goal).where('goals.title LIKE ?', "%#{title}%")
  }

  scope :search_thinker, lambda { |name|
    joins(:thinker).where('thinkers.name LIKE ?', "%#{name}%")
  }

  scope :search_worker, lambda { |name|
    joins(:thinker, :worker).where('thinkers.name LIKE ?', "%#{name}%")
  }

  def destroy_and_associate_reason(reason, current_thinker)
    ActiveRecord::Base.transaction do
      begin
        self.worker = nil
        self.status = Status.backlog.first
        save

        destroy

        reason = Reason
                 .where(related: self).first_or_create

        reason.text    = reason
        reason.thinker = current_thinker

        reason.save
      rescue => ex
        puts ex.message
      end
    end
  end

  def average
    return 0 if workloads.length.zero?

    @average ||= workloads.average(:value).round(2) if workloads.length > 0
  end

  def variance
    votes = workloads.pluck(:id)

    return 0 if votes.length == 1

    average = id_average

    @variance ||= (votes.inject(0) { |accum, i| accum + (i - average)**2 }) / (votes.length - 1)
  end

  def id_average
    workloads.average(:id) if workloads.length > 0
  end

  def standard_deviation
    @standard_deviation ||= Math.sqrt(variance).to_int
  end

  def progress
    return false if workload == Workload.infinity.first

    statuses = Status.all
    actual_index = statuses.index(status)

    self.status = statuses.fetch(actual_index + 1)
  end

  def voted?(thinker)
    votes.where(thinker: thinker).first().present?
  end

  def contributed?(thinker)
    comments = self.comments
    comments.where(thinker: thinker).present? || liked?(thinker)
  end

  def liked?(thinker)
    has_liked = false

    comments.each do |comment| 
      next has_liked = true unless has_liked &&
                                   !comment.impressionist_count(user_id: thinker).zero?
    end

    has_liked
  end

  def done?
    return true if status == Status.done.first
  end

  def in_progress?
    return true if status == Status.in_progress.first
  end

  def count_occurrences(search)
    (title.scan(/#{search}/).count * 2) + description.scan(/#{search}/).count
  end

  def visible_text
    "##{serial} #{title}"
  end

  def save_and_check_project_condition
    state = true

    begin
      transaction do
        save

        project.plan! if project.definition?
      end
    rescue ActiveRecord::RecordInvalid
      state = false
    end

    state
  end

  private

  def update_goal_and_release
    ActiveRecord::Base.transaction do
      begin
        # if release.blank?
        #   unless release_id_was.blank?
        #     release_was = Release.friendly.find(release_id_was)
        #     unless release_was.blank?
        #       release_was.progress = release_was.progress_percentage
        #       release_was.save
        #     end
        #   end
        # else
        #   release.progress = release.progress_percentage
        #   release.save
        # end

        if goal.blank?
          unless goal_id_was.blank?
            goal_was = Goal.find(goal_id_was)
            unless goal_was.blank?
              goal_was.progress = goal_was.progress_percentage
              goal_was.save
            end
          end
        else
          goal.progress = goal.progress_percentage
          goal.save
        end
      rescue => ex
        puts ex.message
      end
    end
  end

  # TODO Move to something in project.rb
  def update_project_condition
    if project.definition? && project.tasks.where.not(goal_id: nil).present?
      project.plan!
    else
      project.definition!
    end
  end

  def generate_serial
    tasks_count = (Task
                  .with_deleted
                  .where(project_id: project.id)
                  .where(recruitment: recruitment)
                  .maximum('serial') || 0) + 1

    self.serial = tasks_count
  end

  def default_values
    self.status ||= Status.backlog.first
  end
end
