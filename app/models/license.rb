class License < ActiveRecord::Base
  has_many :projects

  validates :name, length: { in: 1..50 }, uniqueness: true
  validates :description, length: { in: 2..1600 }
end
