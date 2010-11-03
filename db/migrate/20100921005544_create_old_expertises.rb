class CreateOldExpertises < ActiveRecord::Migration
  def self.up
    create_table :expertises, :force => true do |e|
      e.integer :member_id, :years
      e.string :description
      e.boolean :yes_no 
    end
  end

  def self.down
    drop_table :expertises
  end
end
