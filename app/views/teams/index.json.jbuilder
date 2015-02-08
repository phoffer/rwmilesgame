json.array!(@teams) do |team|
  json.extract! team, :id, :game_id, :name, :slug, :status, :allstar_bonus
  json.url team_url(team, format: :json)
end
