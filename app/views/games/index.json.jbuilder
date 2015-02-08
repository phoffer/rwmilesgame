json.array!(@games) do |game|
  json.extract! game, :id, :current_week_id, :year, :status, :closes_at, :count
  json.url game_url(game, format: :json)
end
