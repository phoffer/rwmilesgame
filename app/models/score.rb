class Score < ActiveRecord::Base
  belongs_to :team
  belongs_to :week
  has_many :posts

  def opponent
    Score.find(self.opponent_id)
  end

  def update_scores
    p = self.posts.order(total: :desc).pluck(:total)
    self.total  = p.sum
    self.mb     = self.team.players.count
    self.po     = p.count#{ |post| post.posted_at < self.week.closes_at }
    self.high   = p.first
    scored = p.take(self.week.count)
    self.low    = scored.last
    self.avg    = (scored.sum / scored.length).round(1)
    self.points = scored.sum * (self.mb == self.po ? 1.1 : 1.0)
    save
  end
end
