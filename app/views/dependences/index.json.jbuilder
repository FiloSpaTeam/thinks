json.array!(@dependences) do |dependence|
  json.extract! dependence, :id
  json.url dependence_url(dependence, format: :json)
end
