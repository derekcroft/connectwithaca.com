class ChangeMemberIdToProfileIdInExpertises < ActiveRecord::Migration
  def self.up
    remove_column :expertises, :member_id
    add_column :expertises, :profile_id, :integer
  end

  def self.down
    remove_column :expertises, :profile_id
    add_column :expertises, :member_id, :integer
  end
end
