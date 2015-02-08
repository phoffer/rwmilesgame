class Post < ActiveRecord::Base
  belongs_to :player
  belongs_to :week
  belongs_to :score
end
