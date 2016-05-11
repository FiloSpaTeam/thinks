class Release < ActiveRecord::Base
  paginates_per 10
  max_paginates_per 50

  filterrific(
    available_filters: [
      :sorted_by,

      :search_title,
      :search_task,

      :progress_lower_than
    ]
  )

  belongs_to :project

  validates_uniqueness_of :end_at, scope: :project_id

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^progress_/
      # Simple sort on the name colums
      order("releases.progress #{ direction }")
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :search_title, lambda { |title|
    where('title LIKE ?', "%#{title}%")
  }

  scope :search_task, lambda { |title|
    joins(:tasks).where('tasks.title LIKE ?', "%#{title}%").distinct
  }

  scope :progress_lower_than, lambda { |value|
    where('progress < ?', value)
  }
end
