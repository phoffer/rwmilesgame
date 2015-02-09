require 'simple-rss'
require 'nokogiri'
require 'net/http'

class Week < ActiveRecord::Base
  belongs_to :game
  has_many :scores
  has_many :posts

  before_create :set_count

  MESSAGE_BODY_CSS = 'div.sharedContentBody.visualIEFloatFix.postBody'
  SPLIT_REGEX = ','

  def closes_at
    self.game.closes_at + self.number.weeks
  end
  def open # one time to set status and set up matchups
    update_attribute(:status, 1)
    if self.thread_url
      # binding.pry
      import_matchups
    end
    # set up matchups
  end
  def get_thread
    # handle the fact that it sometimes fails?
  end
  def import_matchups
    posts, op = load_thread
    matchups = op.children.detect{|ch| ch.text.include? 'Head2Head Challenge' }.next.css('b').map(&:text).each_slice(2).to_a
    # self.game.teams
    matchups.map do |a,b|
      aa = self.game.teams.find_by_name(a).scores.create(week_id: self.id)
      bb = self.game.teams.find_by_name(b).scores.create(week_id: self.id)
      aa.update_attribute(:opponent_id, bb.id) && bb.update_attribute(:opponent_id, aa.id)
    end.all?
  end
  def open?
    self.thread_url && self.status == 1
  end
  def ready?
    check_for_thread && self.status.zero?
  end
  def check_for_thread
    rss = SimpleRSS.parse(Net::HTTP.get(URI(Game::FORUM_RSS)))
    thread = rss.items.detect{ |item| item.title.include?("#{self.game.year}in#{self.game.year}") && item.title.include?("Week_#{self.number}_-_Post") }
    thread && self.update_attributes(thread_url: thread.link)
  end
  def update_scores
    check_for_thread unless self.thread_url
    parse_thread.all?# unless self.updated_at > self.closes_at
  end
  def close # when thread is closed
    update_scores unless caller_locations(1,1)[0].label == 'update_scores'
    update_attribute(:status, 2)
  end
  def printer_url
    self.thread_url.gsub('/topic/', '/printer-friendly-topic/')
  end
  def load_thread
    i ||= 0
    doc = Nokogiri::HTML(Net::HTTP.get(URI(self.printer_url)))
    posts = doc.css('div.printerFriendlyPostWrapper.solidBorderedWrapper')
    op    = posts.shift.css(MESSAGE_BODY_CSS)
  rescue
    sleep 1
    retry if (i += 1) < 3
  ensure
    return posts, op
  end
  private
    def set_count
      self.count = self.game.count
    end
    def parse_thread
      posts, op = load_thread
      self.game.players.on_IR.each{|p| p.posts.find_or_create_by(week_id: self.id).update_attribute(:status, 1) } # need to hook up to score
      posts.each {|p| parse_post(p) }
      self.game.players.where(status: 1).each{ |player| parse_post(1, ir: player.name) }
      self.scores.map(&:update_scores)
      # update_attribute(:updated_at, Time.now)
    end
    def parse_post(post, ir: nil)
      unless ir
        text = post.css("#{MESSAGE_BODY_CSS} > p:nth-child(1)").text.strip.gsub("\u00A0", '')
        if text.empty?
          text = post.css(MESSAGE_BODY_CSS).text.strip.gsub("\u00A0", '')
        end
        return nil if text.empty?
        player, week, miles = text.split(SPLIT_REGEX).map(&:strip)
        if week.to_i != self.number
          post.css(MESSAGE_BODY_CSS).map { |p| p.text.strip.gsub("\u00A0", '') } # find correct week
        end
        return if text['deadline'] && text['passed']
        # if author.downcase != player.downcase
        #   puts author, player
        # end
      else
        player, miles = ir, 0
      end
      p = self.game.player(player)
      if p
        score = p.team.scores.find_by(week_id: self.id) || Score.new
        puts score.inspect
        m = p.posts.find_or_create_by(week_id: self.id, score_id: score.id)
        m.update_attribute(:total, miles.to_f)
        m.update_attribute(:status, (ir ? 1 : 0))
        p.update_attribute(:total, p.posts.sum(:total))
      end
    end
end
