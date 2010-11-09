class AddOtherExpertiseToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :other_expertise, :text
    add_column :profiles, :dealer_system1, :string
    add_column :profiles, :dealer_system2, :string
    add_column :profiles, :dealer_system3, :string
    add_column :profiles, :language1, :string
    add_column :profiles, :language2, :string
    add_column :profiles, :language3, :string
  end

  def self.down
    remove_column :profiles, :other_expertise
    remove_column :profiles, :dealer_system1
    remove_column :profiles, :dealer_system2
    remove_column :profiles, :dealer_system3
    remove_column :profiles, :language1
    remove_column :profiles, :language2
    remove_column :profiles, :language3
  end
end
