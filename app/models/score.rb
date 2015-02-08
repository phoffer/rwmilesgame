class Score < ActiveRecord::Base
  belongs_to :team
  belongs_to :week
  belongs_to :opponent
end
