class Profile < ActiveRecord::Base
  belongs_to :member

  has_many :projects, :dependent => :destroy
  accepts_nested_attributes_for :projects, :allow_destroy => true

  has_many :profile_expertises
  has_many :expertises, :through => :profile_expertises

  def has_expertise?(expertise)
    self.expertises.exists?(expertise)
  end

  def years_experience(expertise)
    self.has_expertise?(expertise) ? self.profile_expertises.find_by_expertise_id(expertise.id).try(:years) : nil
  end
end
