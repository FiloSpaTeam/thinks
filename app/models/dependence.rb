class Dependence < ActiveRecord::Base
  belongs_to :project

  def self.external
    Proc.new { |dep| !dep.external? }
  end

  validates :url, presence: true, unless: external
  validates :reason, length: { in: 20..1600 }
end
