class Category < ActiveRecord::Base
  has_many :projects

  validates :t_name, presence: true
  validates :t_description, presence: true

  def name
    I18n.translate("category.#{t_name}")
  end
end
