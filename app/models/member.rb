class Member < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy
  has_one :profile, :dependent => :destroy
  has_many :expertises, :dependent => :destroy

  public
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def name
    "#{self.last_name}, #{self.first_name}"
  end
end
