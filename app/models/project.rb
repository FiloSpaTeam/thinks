class Project < ActiveRecord::Base
  extend FriendlyId

  filterrific(
    default_filter_params: { sorted_by: 'title_asc' },
    available_filters: [
      :sorted_by,
      :search_query
    ]
  )

  friendly_id :title, :use => :slugged

  has_and_belongs_to_many :languages
  has_and_belongs_to_many :thinkers

  has_many :dependencies
  has_many :goals
  has_many :tasks
  has_many :workers, through: :tasks do
    def active
      where("tasks.status_id = ?", Status.in_progress.first.id)
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

  # validate :expiration_date_cannot_be_in_the_past

  # def expiration_date_cannot_be_in_the_past
  #   if release_at.present? && release_at < Date.today
  #     errors.add(:release_at, "can't be in the past")
  #   end
  # end

  scope :search_query, lambda { |query|
    where(title: [*query])
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

  def progress_percentage
    tasks      = self.tasks
    0 if tasks.empty? || tasks.nil?

    tasks_done = tasks.where({ status_id: Status.done })

    total_tasks_number      = tasks.length
    total_tasks_done_number = tasks_done.length

    @progress_percentage = total_tasks_done_number * 100 / (total_tasks_number.nonzero? || 1)
  end
end
