class Member < ActiveRecord::Base
  belongs_to :user, :dependent => :destroy

  public
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def name
    "#{self.last_name}, #{self.first_name}"
  end
end
