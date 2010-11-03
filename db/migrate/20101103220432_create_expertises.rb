class CreateExpertises < ActiveRecord::Migration
  def self.up
    create_table :expertises do |t|
      t.string :name
      t.timestamps
    end

    Expertise.create!([
      { :name => "Dealership Sales Experience" },
      { :name => "Dealership Service Experience" },
      { :name => "Group Facilitation Skills" },
      { :name => "CSI/SSI Consulting" },
      { :name => "Process Redesign " },
      { :name => "Large Audience Presentations" },
      { :name => "Broadcast Training" },
      { :name => "Ride & Drive Facilitation" },
      { :name => "Driving Instruction" },
      { :name => "Instructional Design" },
      { :name => "Train-the-Trainer Facilitation" },
      { :name => "Trainer Management" },
      { :name => "Curriculum Development" },
      { :name => "Sales Skills Training" },
      { :name => "Service Soft Skills Training" },
      { :name => "Service Technical Training" },
      { :name => "Management Consulting" },
      { :name => "Marine Consulting " }
    ])
  end

  def self.down
    drop_table :expertises
  end
end
