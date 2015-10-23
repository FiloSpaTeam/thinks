class Goal < ActiveRecord::Base
  filterrific(
    available_filters: [
      :sorted_by,
      :search_query
    ]
  )

  belongs_to :project
  belongs_to :thinker

  has_many :tasks

  validates :title, length: {maximum: 60}, presence: true

  scope :search_query, lambda { |query|
    where(title: [*query]) 
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

  def progress_percentage
    tasks      = self.tasks
    0 if tasks.empty? || tasks.nil?

    tasks_done = tasks.where({ status_id: Status.done })

    total_tasks_number      = tasks.length
    total_tasks_done_number = tasks_done.length

    @progress_percentage = total_tasks_done_number * 100 / (total_tasks_number.nonzero? || 1)
  end
end
