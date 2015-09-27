json.array!(@sprints) do |sprint|
  json.extract! sprint, :id, :title, :description, :goal, :obtained, :project_id
  json.url sprint_url(sprint, format: :json)
end
