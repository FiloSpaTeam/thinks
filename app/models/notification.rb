class Notification < ActiveRecord::Base
  filterrific(
    default_filter_params: { },
    available_filters: [
      :sorted_by
    ]
  )

  belongs_to :thinker
  belongs_to :sprint
  belongs_to :project
  belongs_to :goal
  belongs_to :task, -> { with_deleted }

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

  def self.user(thinker)
    where.not(thinker: thinker)
         .where(project: thinker.contributions
              .where('intensity > ?', Contribution.intensities[:nothing]))
         .where.not(id: thinker.notifications.pluck(:id))
  end
end
