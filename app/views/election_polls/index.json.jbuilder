json.array!(@election_polls) do |election_poll|
  json.extract! election_poll, :id
  json.url election_poll_url(election_poll, format: :json)
end
