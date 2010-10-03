class Member < ActiveRecord::Base
  before_create :generate_profile

  belongs_to :user
  has_one :profile, :dependent => :destroy

  public
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def name
    "#{self.last_name}, #{self.first_name}"
  end

  protected
  def generate_profile
    self.create_profile unless self.profile
  end
end
