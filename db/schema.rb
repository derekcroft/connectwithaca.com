# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101103220432) do

  create_table "expertises", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "middle_initial"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.integer  "user_id"
    t.boolean  "active",         :default => true
    t.string   "personal_email"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "home_phone"
    t.string   "business_phone"
    t.string   "mobile_phone"
    t.string   "url"
    t.text     "internal_note"
  end

  create_table "profiles", :force => true do |t|
    t.string   "title"
    t.string   "location"
    t.integer  "years_experience"
    t.text     "biography"
    t.boolean  "sample"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.integer  "member_id"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.boolean  "show_on_profile"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.boolean  "admin",                                    :default => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
