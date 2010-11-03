class DropOldExpertisesTable < ActiveRecord::Migration
  def self.up
    drop_table :expertises
  end

  def self.down
  end
end
