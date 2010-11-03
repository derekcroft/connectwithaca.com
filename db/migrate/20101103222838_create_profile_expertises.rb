class CreateProfileExpertises < ActiveRecord::Migration
  def self.up
    create_table :profile_expertises do |t|
      t.references :profile
      t.references :expertise
      t.integer :years
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_expertises
  end
end
