class Team < ActiveRecord::Base
  belongs_to :game
  has_many :players
  has_many :scores

  before_create :generate_slug

  private
  def generate_slug
    self.slug = self.name.downcase.gsub(/[^a-z0-9\s]/i, '').gsub(' ', '-')
  end
end
