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
  extend FriendlyId
  friendly_id :title, use: :slugged

  acts_as_paranoid

  is_impressionable counter_cache: true

  #has_attachment :main_image, accept: [:jpg, :png]
  #has_attachment :logo, accept: [:jpg, :png]

  attr_accessor :skip_motto_validation

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
  has_many :subprojects, class_name: 'Project'

  belongs_to :license
  belongs_to :thinker
  belongs_to :cycle
  belongs_to :category
  belongs_to :project

  enum contribution_type: %i[open with_recruiting closed]
  enum approach_type: %i[agile waterfall]
  enum status: %i[draft active suspended]
  enum conditions: %i[start definition plan work]

  validates :title, length: { in: 2..60 }, uniqueness: true
  validates :motto, length: { maximum: 240 }, presence: true, if: lambda {
    project.nil? && skip_motto_validation.nil?
  }
  validates :description, length: { in: 2..1600 }
  validates :thinker_id, presence: true, on: :create
  validates :slug, presence: true
  validates :recruitment_text, presence: true, if: -> { with_recruiting? }

  after_save :check_if_past_project
  after_save :update_contribution_thinker

  before_create :generate_serial

  scope :with_title_or_description, lambda { |query|
    where('to_tsvector(title) @@ to_tsquery(?) or lower(description) LIKE ?', "'#{query.downcase}':*", "%#{query.downcase.strip}%")
  }

  scope :with_thinker_name, lambda { |query|
    joins(:thinker).where('to_tsvector(thinkers.name) @@ to_tsquery(?)', "'#{query.downcase}':*")
  }

  scope :with_thinker, lambda { |thinker|
    where(thinker: Thinker.friendly.find(thinker))
  }

  scope :with_category, lambda { |category|
    where(category: Category.find(category))
  }

  def last_notification_update
    notifications.last
  end

  def generate_serial
    self.serial = SecureRandom.hex(64)
  end

  def team
    contributions.distinct.select(&:partecipate?)
  end

  def part_of_team?(thinker)
    # thinker == self.thinker || !team.select { |contribution| contribution.thinker_id == thinker.id }.empty?
    assigned_roles.where(thinker: thinker).present?
  end

  def participant?(thinker)
    return false unless part_of_team?(thinker)

    contributions
      .where(thinker: thinker)
      .where(intensity: Contribution.intensities[:partecipate])
      .present?
  end

  def recruit?(thinker)
    return false if assigned_roles
                    .where(thinker: thinker)
                    .where.not(team_role: TeamRole.team_member.first)
                    .present? || open?

    tasks
      .where(recruitment: true)
      .where(thinker: thinker)
      .done
      .blank?
  end

  def recruitment_demand?(thinker)
    tasks
      .where(recruitment: true)
      .where(thinker: thinker)
      .present?
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
    return nil unless started?

    sprints.last
  end

  def actual_day_of_sprint
    number_of_day = 1

    unless sprint.nil?
      number_of_day = (DateTime.now.to_date - sprint.created_at.to_date).to_i + 1
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
    return unless started? || sprints.count.zero?

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

  def suspend(state)
    self.suspended = state

    save
  end
end
