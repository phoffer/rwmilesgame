require 'rubyXL'
class Game < ActiveRecord::Base
  has_many :teams
  has_many :weeks

  STATUS = [:future, :open, :closed]
  FORUM_RSS = 'http://community.runnersworld.com/forum/team-challenges?rss=true'


  def open
    import_roster if self.players.empty?
    d = Date.new(self.year, 1, 1)
    w = self.weeks.create(number: 1, days: d.end_of_week - d + 1)
    self.update_attributes(current_week_id: w.id, status: 1)
  end
  def open?
    current_week && self.status == 1
  end
  def update_scores
    if open?
      current_week.update_scores
    end
  end
  def close # close at end of the year
    # 
  end
  def init(roster = nil)
    roster ? import_roster(roster) : import_roster
    open
    1 while check_for_new_week
  end
  def update_stuff
    if Time.now > current_week.closes_at
      check_for_new_week
    elsif current_week.status == 1
      current_week.update_scores
    else
      nil
    end
  end

  def check_for_new_week
    if next_week.ready?
      close_week
      self.update_attribute(:current_week_id, next_week.id)
      current_week.open
      current_week.update_scores
    else
      nil
    end
  end

  def players
    Player.where(team_id: self.teams.ids)
  end
  def current_week
    Week.find_by_id(self.current_week_id)
  end
  def current_week_number
    current_week.number
  end
  def next_week
    self.weeks.find_or_create_by(number: self.current_week.number + 1)
  end
  def close_week(number = nil)
    week = self.weeks.find_by(number: number) || current_week
    week.close
    # next_week
  end
  def import_roster(xlsx = 'misc/teams.xlsx')
    workbook = RubyXL::Parser.parse(xlsx)
    worksheet = workbook[2]
    sheetdata = worksheet.extract_data
    update_at = sheetdata.shift
    header    = sheetdata.shift

    sheetdata.map do |arr|
      next nil if arr.try(:first).nil?
      t = self.teams.find_or_create_by(name: arr[1])
      p = t.players.find_or_create_by(name: arr[0])
      p.update_attributes(goal: arr[2], captain: (arr[7] == 'Yes'), status: (arr[6] == 'Yes' ? 1 : 0))
    end
    self.teams.find_by(name: 'Pinch Hitter').update_attribute(:status, 1)
    self.teams.find_by(name: 'Individual').update_attribute(:status, 2)
  end
  def player(name)
    self.players.by_name(name).first
  end
  def self.current
    find_by(status: 1)
  end
end
