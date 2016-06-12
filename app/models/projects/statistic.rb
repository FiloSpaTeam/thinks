class Projects::Statistic < ActiveRecord::Base
  def self.columns
    @columns ||= []
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  self.table_name = 'projects'

  # column :with_first_section, :integer
  # column :with_second_section, :integer
  # column :with_third_section, :integer

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
