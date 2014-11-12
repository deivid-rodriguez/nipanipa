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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141112151433) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "continents", force: true do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "continents", ["code"], name: "index_continents_on_code", unique: true, using: :btree

  create_table "conversations", force: true do |t|
    t.string   "subject"
    t.integer  "from_id"
    t.integer  "to_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "deleted_from", default: false
    t.boolean  "deleted_to",   default: false
  end

  create_table "countries", force: true do |t|
    t.string   "code"
    t.integer  "continent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "countries", ["code"], name: "index_countries_on_code", unique: true, using: :btree

  create_table "donations", force: true do |t|
    t.integer  "user_id"
    t.decimal  "amount",      precision: 4, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "feedback_id"
  end

  create_table "feedbacks", force: true do |t|
    t.text     "content"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feedbacks", ["recipient_id", "updated_at"], name: "index_feedbacks_on_recipient_id_and_updated_at", using: :btree
  add_index "feedbacks", ["sender_id", "recipient_id"], name: "index_feedbacks_on_sender_id_and_recipient_id", unique: true, using: :btree
  add_index "feedbacks", ["sender_id", "updated_at"], name: "index_feedbacks_on_sender_id_and_updated_at", using: :btree

  create_table "language_skills", force: true do |t|
    t.integer "user_id"
    t.integer "language_id"
    t.string  "level"
  end

  add_index "language_skills", ["language_id"], name: "index_language_skills_on_language_id", using: :btree
  add_index "language_skills", ["user_id", "language_id"], name: "index_language_skills_on_user_id_and_language_id", unique: true, using: :btree
  add_index "language_skills", ["user_id"], name: "index_language_skills_on_user_id", using: :btree

  create_table "languages", force: true do |t|
    t.string "code", limit: 2
    t.string "name"
  end

  create_table "messages", force: true do |t|
    t.text     "body"
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", force: true do |t|
    t.integer "user_id"
    t.string  "name"
    t.string  "image"
  end

  create_table "regions", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regions", ["code", "country_id"], name: "index_regions_on_code_and_country_id", unique: true, using: :btree

  create_table "sectorizations", force: true do |t|
    t.integer "user_id"
    t.integer "work_type_id"
  end

  add_index "sectorizations", ["user_id", "work_type_id"], name: "index_sectorizations_on_user_id_and_work_type_id", unique: true, using: :btree
  add_index "sectorizations", ["user_id"], name: "index_sectorizations_on_user_id", using: :btree
  add_index "sectorizations", ["work_type_id"], name: "index_sectorizations_on_work_type_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "type"
    t.string   "encrypted_password",     default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "state"
    t.string   "country"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "reset_password_sent_at"
    t.string   "reset_password_token"
    t.integer  "karma",                  default: 0
    t.text     "accomodation"
    t.text     "skills"
    t.integer  "min_stay"
    t.integer  "hours_per_day"
    t.integer  "days_per_week"
    t.integer  "availability_mask"
    t.integer  "region_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude", using: :btree

  create_table "work_types", force: true do |t|
    t.string "name"
    t.string "description"
  end

end
