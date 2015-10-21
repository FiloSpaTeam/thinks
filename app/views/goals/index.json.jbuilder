json.array!(@goals) do |goal|
  json.extract! goal, :id
  json.url goal_url(goal, format: :json)
end
