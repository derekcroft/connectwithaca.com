class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.boolean :show_on_profile
      t.references :profile
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
