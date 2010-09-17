class CreateProfiles < ActiveRecord::Migration
  def self.up
    # we'll also need latest projects and expertises
    create_table :profiles do |t|
      t.string :title, :location
      t.integer :years_experience
      t.text :biography
      t.boolean :sample
      #t.string :image1, :image1_thumb
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
