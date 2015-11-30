class Task < ActiveRecord::Base
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

      :workload_lower_than
    ]
  )

  has_many :votes
  has_many :workloads, through: :votes
  has_many :comments

  has_many :likes, through: :comments

  belongs_to :project
  belongs_to :goal
  belongs_to :thinker
  belongs_to :worker, class_name: "Thinker", foreign_key: "worker_thinker_id"
  belongs_to :status

  before_create :generate_serial
  before_create :default_values

  before_save :set_release

  validates :title, length: { maximum: 60 }, presence: true
  validates :description, length: { minimum: 30 }

  default_scope { order('serial DESC') }

  scope :status_progress, lambda { |status| where status: status }
  scope :in_progress, lambda { where status: Status.in_progress }
  scope :done, lambda { where status: Status.done }

  scope :ready_to_sprint, lambda {
    where("standard_deviation < ?", 3).where(status: Status.release)
  }

  scope :workload_lower_than, lambda { |value|
    subquery = unscoped.joins(:workloads).group("tasks.id").select("AVG(workloads.value) as average, tasks.id") 

    unscoped.from("(#{subquery.to_sql}) t").where("t.average < ?", value).select("t.average, tasks.*").joins("INNER JOIN tasks on t.id = tasks.id ")
  }

  scope :with_goal, lambda { |goal|
    where(:goal => goal)
  }

  scope :with_worker, lambda { |worker|
    where(:worker => worker)
  }

  scope :with_thinker, lambda { |thinker|
    where(:thinker => thinker)
  }

  scope :search_title, lambda { |query|
    where("title LIKE ?", "%#{query}%")
  }

  scope :search_goal, lambda { |title|
    joins(:goal).where("goals.title LIKE ?", "%#{title}%")
  }

  scope :search_thinker, lambda { |name|
    joins(:thinker).where("thinkers.name LIKE ?", "%#{name}%")
  }

  scope :search_worker, lambda { |name|
    joins(:thinker, :worker).where("thinkers.name LIKE ?", "%#{name}%")
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title_/
      # Simple sort on the name colums
      order("LOWER(tasks.title) #{ direction }")
    when /^workload_/
      # Simple sort over workload
      unscoped.joins(:workloads).group("tasks.id").order("AVG(workloads.value) #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :with_current_thinker, lambda { |current_thinker| 
    status_done = Status.done.first

    joins(:votes).where("(votes.thinker_id = ? and tasks.status_id != ?) or (tasks.status_id = ?)", current_thinker, status_done, status_done)
  }

  # This method provides select options for the `sorted_by` filter select input.
  # It is called in the controller as part of `initialize_filterrific`.
  def self.options_for_sorted_by sort_option
    options = {
      :title => [
        ['Title (a-z)', 'title_asc'],
        ['Title (z-a)', 'title_desc']
      ],
      :workload => [
        ['Low -> High', 'workload_asc'],
        ['High -> Low', 'workload_desc']
      ]
    }

    return options[sort_option]
  end

  def average
    return 0 if workloads.length.zero?

    @average ||= workloads.average(:value).round(2) if workloads.length > 0
  end

  def variance
    votes   = workloads.pluck(:id)

    return 0 if votes.length == 1

    average = self.id_average

    @variance ||= (votes.inject(0) { |accum, i| accum + (i - average)**2 }) / (votes.length - 1)
  end

  def id_average
    workloads.average(:id) if workloads.length > 0
  end

  def standard_deviation
    variance = self.variance

    @standard_deviation ||= Math.sqrt(variance).to_int;
  end

  def progress
    return false if self.workload == Workload.infinity.first

    statuses = Status.all
    actual_index = statuses.index(self.status)

    self.status = statuses.fetch(actual_index + 1)
  end

  def voted?(thinker)
    self.votes.where(:thinker => thinker).first().present?
  end

  def contributed?(thinker)
    comments = self.comments
    comments.where(:thinker => thinker).present? or liked?(thinker)
  end

  def liked?(thinker)
    likes = self.likes

    likes.where(:thinker => thinker).present?
  end

  def ready?
    if project.minimum_team_number > self.votes.length || self.standard_deviation > 2
      return false
    else
      return true
    end
  end

  def done?
    return true if status == Status.done.first
  end

  private

    def generate_serial
      tasks_count = Task.where({project_id: self.project.id}).count
      tasks_count += 1

      self.serial = tasks_count
    end

    def default_values
      self.status ||= Status.backlog.first
    end

    def set_release
      if self.status == Status.backlog.first && self.workloads.size >= self.project.minimum_team_number
        self.status = Status.release.first
      end
    end
end
