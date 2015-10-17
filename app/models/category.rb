class Category < ActiveRecord::Base
  has_many :projects

  def name
    I18n.translate("category.#{self.t_name}")
  end
end
