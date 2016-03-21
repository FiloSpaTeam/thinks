class Project < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  acts_as_paranoid

  filterrific(
    default_filter_params: { sorted_by: 'title_asc' },
    available_filters: [
      :sorted_by,
      :search_title
    ]
  )

  has_attachment :main_image, accept: [:jpg, :png]

  has_and_belongs_to_many :languages

  has_many :contributions
  has_many :dependencies
  has_many :goals, :dependent => :destroy
  has_many :tasks, :dependent => :destroy
  has_many :workloads, through: :tasks, :dependent => :destroy
  has_many :sprints, :dependent => :destroy
  has_many :workers, -> { distinct.unscoped }, through: :tasks do
    def active
      where('tasks.status_id = ?', Status.in_progress.first.id)
    end
  end

  belongs_to :license
  belongs_to :thinker
  belongs_to :cycle
  belongs_to :category

  validates :minimum_team_number, numericality: { only_integer: true, greater_than: 1 }
  validates :title, length: { in: 2..60 }, uniqueness: true
  validates :description, length: { in: 2..1600 }
  validates :license_id, presence: true
  validates :thinker_id, presence: true, on: create
  validates :slug, presence: true
  validates :cycle, presence: true

  after_save :check_if_past_project

  # validate :expiration_date_cannot_be_in_the_past

  # def expiration_date_cannot_be_in_the_past
  #   if release_at.present? && release_at < Date.today
  #     errors.add(:release_at, "can't be in the past")
  #   end
  # end

  scope :search_title, lambda { |query|
    where("title LIKE ?", "%#{query}%")
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title_/
      # Simple sort on the name colums
      order("LOWER(projects.title) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by
    [
      ['Title (a-z)', 'title_asc'],
      ['Title (z-a)', 'title_desc']
    ]
  end

  def part_of_team?(thinker)
    thinker == self.thinker || !contributions.select{ |contribution| contribution.thinker == thinker && contribution.partecipate? }.empty?
  end

  def progress_percentage
    tasks      = self.tasks
    0 if tasks.empty? || tasks.nil?

    tasks_done = tasks.where({ status_id: Status.done })

    total_tasks_number      = tasks.length
    total_tasks_done_number = tasks_done.length

    @progress_percentage = total_tasks_done_number * 100 / (total_tasks_number.nonzero? || 1)
  end

  def started?
    return false if self.release_at.nil? || (self.release_at > DateTime.now.to_date)

    true
  end

  def countdown
    return -1 if release_at.nil?

    (release_at - DateTime.now.to_date).to_i
  end

  def sprint
    return 0 if !started?

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
    return 100 * self.actual_day_of_sprint / cycle.days
  end

  def days_from_start
    (DateTime.now.to_date - release_at)
  end

  def check_if_past_project
    if started?
      Sprint.update_sprint_system
    end
  end
end
