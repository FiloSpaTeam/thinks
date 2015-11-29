class Workload < ActiveRecord::Base
  has_many :tasks, through: :votes

  default_scope { order(:value) }

  scope :infinity, lambda { where value: 9999 }

  def self.closest(value)
    workloads = pluck(:value)

    workloads.min_by { |x| (x.to_f - value).abs }
  end
end
