class Profile < ActiveRecord::Base
  belongs_to :member

  has_many :projects, :dependent => :destroy
  accepts_nested_attributes_for :projects, :allow_destroy => true

  has_many :profile_expertises
  has_many :expertises, :through => :profile_expertises

  def has_expertise?(expertise)
    self.expertises.exists?(expertise)
  end
end
