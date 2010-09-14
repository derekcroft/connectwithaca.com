class AddFieldsForTrainers < ActiveRecord::Migration
  def self.up
    add_column :members, :first_name, :string
    add_column :members, :middle_initial, :string
    add_column :members, :last_name, :string
    add_column :members, :phone, :string
    add_column :members, :email, :string
    add_column :members, :address, :string
  end

  def self.down
    remove_column :members, :first_name
    remove_column :members, :middle_initial
    remove_column :members, :last_name
    remove_column :members, :phone
    remove_column :members, :email
    remove_column :members, :address
  end
end
