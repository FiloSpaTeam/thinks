json.array!(@cycles) do |cycle|
  json.extract! cycle, :id, :translation_code, :description, :days
  json.url cycle_url(cycle, format: :json)
end
