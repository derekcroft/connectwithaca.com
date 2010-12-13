class Profile < ActiveRecord::Base
  belongs_to :member

  has_many :projects, :dependent => :destroy
  accepts_nested_attributes_for :projects, :allow_destroy => true

  has_many :profile_expertises
  has_many :expertises, :through => :profile_expertises

  def has_expertise?(expertise)
    self.expertises.exists?(expertise)
  end

  def years_of_expertise(expertise)
    self.has_expertise?(expertise) ? self.profile_expertises.detect {|pe| pe.expertise_id == expertise.id}.try(:years) : nil
  end

  def set_years_of_expertise(expertise, years)
    pe = self.profile_expertises.detect { |v| v.expertise_id == expertise.id }
    pe.try(:years=, years) && pe.save
  end
end
