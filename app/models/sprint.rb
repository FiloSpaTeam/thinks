class Sprint < ActiveRecord::Base
  acts_as_paranoid

  paginates_per 15
  max_paginates_per 50

  filterrific(
    available_filters: [
      :sorted_by
    ]
  )

  belongs_to :project

  has_many :answers

  before_create :generate_serial
  before_create :default_values

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^obtained_/
      # Simple sort on the name colums
      order("sprints.obtained #{ direction }")
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.update_sprint_system
    projects = Project.all

    projects.each do |project|
      next unless project.started?

      if project.sprints.count.zero?
        sprint = Sprint.new

        sprint.project = project
        sprint.save

        notification = Notification.new

        notification.project    = project
        notification.thinker_id = 0
        notification.model      = sprint.class.name
        notification.model_id   = sprint.id
        notification.controller = 'sprints'
        notification.action     = 'create'

        notification.save
      else
        last_sprint = project.sprints.last

        if (DateTime.now.to_date - last_sprint.created_at.to_date) == project.cycle.days
          sprint = Sprint.new

          sprint.project = project
          sprint.save

          tasks_last_sprint = project.tasks.done.where('updated_at < ?', sprint.created_at).where('updated_at > ?', last_sprint.created_at)

          last_sprint.obtained = tasks_last_sprint.sum(:workload)
          last_sprint.save

          notification = Notification.new

          notification.project    = project
          notification.thinker_id = 0
          notification.model      = sprint.class.name
          notification.model_id   = sprint.id
          notification.controller = 'sprints'
          notification.action     = 'create'

          notification.save

          notification = Notification.new

          notification.project    = project
          notification.thinker_id = 0
          notification.model      = sprint.class.name
          notification.model_id   = last_sprint.id
          notification.controller = 'sprints'
          notification.action     = 'update'

          notification.save
        end
      end
    end
  end

  def next
    Sprint.where('id > ?', id).first
  end

  private

  def generate_serial
    sprints_count = Sprint.where(project_id: project.id).count
    sprints_count += 1

    self.serial = sprints_count
  end

  def default_values
    self.obtained ||= 0
  end
end
