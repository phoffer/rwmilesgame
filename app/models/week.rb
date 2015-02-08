class Week < ActiveRecord::Base
  belongs_to :game
  has_many :scores
  has_many :posts
end
