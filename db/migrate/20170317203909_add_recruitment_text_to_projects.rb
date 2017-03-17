class AddRecruitmentTextToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :recruitment_text, :text
  end
end
