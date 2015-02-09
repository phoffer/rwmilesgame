class Player < ActiveRecord::Base
  belongs_to :team
  has_many :posts

  before_create :generate_slug

  scope :on_IR, -> { where(status: 1) }
  scope :by_name, ->(name) {where(slug: generate_slug(name)) }

  def move_to_ir
    update_attribute(:status, 1)
  end
  def remove_from_ir
    update_attribute(:status, 0)
  end
  def captain_string
     self.captain ? 'Yes' : 'No'
  end
  def ir_string
    self.status == 1 ? 'Yes' : 'No'
  end

  def self.generate_slug(name)
    name.downcase.gsub(' ', '-')
  end
  private
  def generate_slug
    self.slug = self.class.generate_slug(self.name)
  end
end
