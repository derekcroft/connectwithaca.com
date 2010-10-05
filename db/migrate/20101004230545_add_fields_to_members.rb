class AddFieldsToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :personal_email, :string
    add_column :members, :address2, :string
    add_column :members, :city, :string
    add_column :members, :state, :string
    add_column :members, :zip, :string
    add_column :members, :home_phone, :string
    add_column :members, :business_phone, :string
    add_column :members, :mobile_phone, :string
    add_column :members, :url, :string
    add_column :members, :internal_note, :text
  end

  def self.down
    remove_column :members, :personal_email
    remove_column :members, :address2
    remove_column :members, :city
    remove_column :members, :state
    remove_column :members, :zip
    remove_column :members, :home_phone
    remove_column :members, :business_phone
    remove_column :members, :mobile_phone
    remove_column :members, :url
    remove_column :members, :internal_note
  end
end
