class Team < ActiveRecord::Base
  belongs_to :game
  has_many :players
  has_many :scores
end
