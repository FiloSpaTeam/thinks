class Projects::Statistic < Project
  def self.columns
    @columns ||= []
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  attr_accessor :with_first_section
  attr_accessor :with_second_section
  attr_accessor :with_third_section

  filterrific(
    available_filters: [
      :with_first_section,
      :with_second_section,
      :with_third_section
    ]
  )

  scope :with_first_section, -> (value) { }
  scope :with_second_section, -> (value) { }
  scope :with_third_section, -> (value) { }
end
