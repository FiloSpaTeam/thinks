class ProjectProject < ActiveRecord::Base
  self.table_name = :projects_projects

  belongs_to :father, class_name: 'Project', foreign_key: 'father_project_id'
  belongs_to :child, class_name: 'Project', foreign_key: 'father_project_id'
end
