class Profile < ActiveRecord::Base
  belongs_to :member
  has_many :expertises, :dependent => :destroy

  accepts_nested_attributes_for :expertises, :allow_destroy => true
end
