class Game < ActiveRecord::Base
  has_many :teams
  has_many :weeks

  STATUS = [:future, :open, :closed]

  def players
    Player.where(team_id: self.teams.ids)
  end
  def current_week
    self.weeks.find_by(self.current_week_id)
  end

  def self.current
    find_by(status: 1)
  end
end
