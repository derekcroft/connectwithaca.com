class ProfileExpertise < ActiveRecord::Base
  belongs_to :profile
  belongs_to :expertise
end
