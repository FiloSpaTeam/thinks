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

class Project < ActiveRecord::Base
  include FriendlyId
  friendly_id :title, use: :slugged

  acts_as_paranoid

  is_impressionable counter_cache: true

  paginates_per 24
  max_paginates_per 48

  filterrific(
    available_filters: [
      :sorted_by,

      :search_title
    ]
  )

  has_attachment :main_image, accept: [:jpg, :png]

  has_and_belongs_to_many :languages
  has_and_belongs_to_many :skills

  has_many :contributions
  has_many :assigned_roles
  has_many :dependencies
  has_many :goals, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :workloads, through: :tasks, dependent: :destroy
  has_many :sprints, dependent: :destroy
  has_many :workers, -> { distinct.unscoped }, through: :tasks do
    def active
      where('tasks.status_id = ?', Status.in_progress.first.id)
    end
  end
  has_many :election_polls
  has_many :releases
  has_many :notifications
  has_many :banned_thinkers

  belongs_to :license
  belongs_to :thinker
  belongs_to :cycle
  belongs_to :category
  belongs_to :project

  validates :minimum_team_number, numericality: { only_integer: true, greater_than: 1 }
  validates :title, length: { in: 2..60 }, uniqueness: true
  validates :description, length: { in: 2..1600 }
  validates :thinker_id, presence: true, on: :create
  validates :slug, presence: true

  after_save :check_if_past_project
  after_save :update_contribution_thinker

  before_create :generate_serial

  # validate :expiration_date_cannot_be_in_the_past

  # def expiration_date_cannot_be_in_the_past
  #   if release_at.present? && release_at < Date.today
  #     errors.add(:release_at, "can't be in the past")
  #   end
  # end

  scope :search_title, lambda { |query|
    where('title LIKE ?', "%#{query}%")
  }

  scope :sorted_by, lambda { |sort_option|
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title_/
      order("LOWER(projects.title) #{direction}")
    when /^impressions_count/
      order("impressions_count #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def last_notification_update
    notifications.last
  end

  def generate_serial
    self.serial = SecureRandom.hex(64)
  end

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ['Title (a-z)', 'title_asc'],
      ['Title (z-a)', 'title_desc'],
      ['Less popular first', 'impressions_count_asc'],
      ['Highest popular first', 'impressions_count_desc']
    ]
  end

  def team
    contributions.distinct.select(&:partecipate?)
  end

  def part_of_team?(thinker)
    # thinker == self.thinker || !team.select { |contribution| contribution.thinker_id == thinker.id }.empty?
    assigned_roles.where(thinker: thinker).present?
  end

  def progress_percentage
    tasks = self.tasks
    0 if tasks.empty? || tasks.nil?

    tasks_done = tasks.where(status_id: Status.done)

    total_tasks_number      = tasks.length
    total_tasks_done_number = tasks_done.length

    @progress_percentage = total_tasks_done_number * 100 / (total_tasks_number.nonzero? || 1)
  end

  def started?
    return false if release_at.nil? || (release_at > DateTime.now.to_date)

    true
  end

  def countdown
    return -1 if release_at.nil?

    (release_at - DateTime.now.to_date).to_i
  end

  def sprint
    return 0 unless started?

    sprints.last.serial
  end

  def actual_day_of_sprint
    number_of_day = 1

    if (self.sprint > 0)
      number_of_day = (DateTime.now.to_date - sprints.last.created_at.to_date).to_i + 1
    end

    number_of_day
  end

  def days_percentage
    100 * actual_day_of_sprint / cycle.days
  end

  def days_from_start
    (DateTime.now.to_date - release_at)
  end

  def check_if_past_project
    if started?
      if sprints.count.zero?
        ActiveRecord::Base.transaction do
          sprint = Sprint.new

          sprint.project = self
          sprint.save

          notification = Notification.new

          notification.project    = self
          notification.thinker_id = 0
          notification.model      = sprint.class.name
          notification.model_id   = sprint.id
          notification.controller = 'sprints'
          notification.action     = 'create'

          notification.save
        end
      end
    end
  end

  def update_contribution_thinker
    Contribution.find_or_create_by(project_id: id, thinker_id: thinker.id) do |contribution|
      contribution.intensity = Contribution.intensities[:partecipate]
    end
  end

  def save_first_team_roles
    AssignedRole.find_or_create_by(project_id: id, team_role: TeamRole.product_owner.first) do |role|
      role.thinker = thinker
    end
    AssignedRole.find_or_create_by(project_id: id, team_role: TeamRole.scrum_master.first) do |role|
      role.thinker = thinker
    end
  end
end
