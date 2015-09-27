json.array!(@projects) do |project|
  json.extract! project, :id, :title, :description, :minimum_team_number, :begin_at
  json.url project_url(project, format: :json)
end
