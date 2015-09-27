class Language < ActiveRecord::Base
  has_and_belongs_to_many :projects

  validates :name, length: { in: 1..25 }, uniqueness: true
end
