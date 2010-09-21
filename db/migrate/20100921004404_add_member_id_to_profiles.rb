class AddMemberIdToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :member_id, :integer
  end

  def self.down
    remove_column :profiles, :member_id
  end
end
