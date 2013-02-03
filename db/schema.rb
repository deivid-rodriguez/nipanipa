# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130131202608) do

  create_table "feedbacks", :force => true do |t|
    t.string   "content"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "score"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "feedbacks", ["recipient_id", "updated_at"], :name => "index_feedbacks_on_recipient_id_and_updated_at"
  add_index "feedbacks", ["sender_id", "recipient_id"], :name => "index_feedbacks_on_sender_id_and_recipient_id", :unique => true
  add_index "feedbacks", ["sender_id", "updated_at"], :name => "index_feedbacks_on_sender_id_and_updated_at"

  create_table "locations", :force => true do |t|
    t.string "address"
    t.float  "latitude"
    t.float  "longitude"
  end

  add_index "locations", ["address"], :name => "index_locations_on_address"

  create_table "sectorizations", :force => true do |t|
    t.integer "user_id"
    t.integer "work_type_id"
  end

  add_index "sectorizations", ["user_id", "work_type_id"], :name => "index_sectorizations_on_user_id_and_work_type_id", :unique => true
  add_index "sectorizations", ["user_id"], :name => "index_sectorizations_on_user_id"
  add_index "sectorizations", ["work_type_id"], :name => "index_sectorizations_on_work_type_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",            :default => false
    t.text     "description"
    t.integer  "location_id"
    t.text     "work_description"
    t.string   "type"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "work_types", :force => true do |t|
    t.string "name"
    t.string "description"
  end

end
