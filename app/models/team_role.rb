class TeamRole < ActiveRecord::Base
  scope :product_owner, -> { where t_name: :product_owner }
  scope :scrum_master, -> { where t_name: :scrum_master }
  scope :team_member, -> { where t_name: :team_member }
end
