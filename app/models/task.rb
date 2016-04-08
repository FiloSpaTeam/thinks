class Task < ActiveRecord::Base
  acts_as_paranoid

  paginates_per 10
  max_paginates_per 50

  filterrific(
    available_filters: [
      :sorted_by,

      :search_title,
      :search_goal,
      :search_thinker,
      :search_worker,

      :status_progress,

      :with_goal,
      :with_worker,
      :with_thinker,
      :with_project,

      :workload_lower_than,

      :with_deleted_at
    ]
  )

  has_many :votes
  has_many :workloads, through: :votes
  has_many :comments
  has_many :operations

  has_many :likes, through: :comments

  belongs_to :project
  belongs_to :goal
  belongs_to :thinker
  belongs_to :worker, class_name: 'Thinker', foreign_key: 'worker_thinker_id'
  belongs_to :status

  before_create :generate_serial
  before_validation :default_values

  before_save :set_release

  after_save :update_goal

  validates :title, length: { maximum: 60 }, presence: true
  validates :description, length: { minimum: 30 }
  validates :project_id, presence: true, on: :create
  validates :status_id, presence: true, on: :create
  validates :thinker_id, presence: true, on: :create

  default_scope { order('serial DESC') }

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

  scope :with_deleted_at, lambda { |value|
    only_deleted
  }

  scope :updated_at_in_sprint, lambda { |sprint|
    result = where('updated_at >= ?', sprint.created_at)

    return result if sprint.next.nil?

    result.where('updated_at < ?', sprint.next.created_at)
  }

  scope :search_title, lambda { |query|
    where('title LIKE ?', "%#{query}%")
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

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title_/
      # Simple sort on the name colums
      order("LOWER(tasks.title) #{direction}")
    when /^workload_/
      # Simple sort over workload
      unscoped
        .joins(:workloads)
        .group('tasks.id')
        .order("AVG(workloads.value) #{direction}")
    else
      fail(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by(sort_option)
    options = {
      title: [
        ['Title (a-z)', 'title_asc'],
        ['Title (z-a)', 'title_desc']
      ],
      workload: [
        ['Low -> High', 'workload_asc'],
        ['High -> Low', 'workload_desc']
      ]
    }

    options[sort_option]
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
    likes.where(thinker: thinker).present?
  end

  def ready?
    if project.minimum_team_number > votes.length ||
       standard_deviation > 2
      return false
    else
      return true
    end
  end

  def done?
    return true if status == Status.done.first
  end

  def in_progress?
    return true if status == Status.in_progress.first
  end

  private

  def update_goal
    if goal.blank?
      return if goal_id_was.blank?

      goal_was = Goal.find(goal_id_was)

      return if goal_was.blank?

      goal_was.progress = goal_was.progress_percentage
      goal_was.save
    else
      goal.progress = goal.progress_percentage
      goal.save
    end
  end

  def generate_serial
    tasks_count = Task.where(project_id: project.id).count + 1

    self.serial = tasks_count
  end

  def default_values
    self.status ||= Status.backlog.first
  end

  def set_release
    if self.status == Status.backlog.first &&
       workloads.size >= project.minimum_team_number
      self.status = Status.release.first
    end
  end
end
