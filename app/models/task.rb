class Task < ActiveRecord::Base
  filterrific(
    available_filters: [
      :sorted_by,
      :search_query,
      :status_progress
    ]
  )

  belongs_to :project
  belongs_to :goal
  belongs_to :thinker
  belongs_to :worker, class_name: "Thinker", foreign_key: "worker_thinker_id"
  belongs_to :status
  belongs_to :workload

  before_create :generate_serial
  before_create :default_values

  before_save :set_progress

  validates :title, length: { maximum: 60 }, presence: true
  validates :description, length: { minimum: 30 }

  default_scope { order('serial DESC') }

  scope :status_progress, lambda { |status| where status: status }
  scope :in_progress, lambda { where status: Status.in_progress }

  scope :search_query, lambda { |query|
    where(title: [*query]) 
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^title_/
      # Simple sort on the name colums
      order("LOWER(tasks.title) #{ direction }")
    when /^workload_/
      # Simple sort over workload
      unscoped.joins(:workload).order("workloads.value #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
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

  def progress
    return false if self.workload == Workload.infinity.first

    statuses = Status.all
    actual_index = statuses.index(self.status)

    self.status = statuses.fetch(actual_index + 1)
  end

  private

    def generate_serial
      tasks_count = Task.where({project_id: self.project.id}).count
      tasks_count += 1

      self.serial = tasks_count
    end

    def default_values
      self.workload ||= Workload.find_by(:value => nil)
      self.status ||= Status.find_by(:translation_code => :backlog)
    end

    def set_progress
      if !self.workload.nil? && self.status == Status.backlog.first
        self.status = Status.release.first
      end
    end
end
