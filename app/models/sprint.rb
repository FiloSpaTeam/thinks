class Sprint < ActiveRecord::Base
  paginates_per 15
  max_paginates_per 50

  filterrific(
    available_filters: [
      :sorted_by
    ]
  )

  belongs_to :project

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

  private

  def default_values
    self.obtained ||= 0
  end
end
