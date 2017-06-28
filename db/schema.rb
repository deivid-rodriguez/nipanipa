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

ActiveRecord::Schema.define(version: 20160714235822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "continents", id: :serial, force: :cascade do |t|
    t.string "code", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_continents_on_code", unique: true
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "code", limit: 255
    t.integer "continent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_countries_on_code", unique: true
    t.index ["continent_id"], name: "index_countries_on_continent_id"
  end

  create_table "donations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.decimal "amount", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feedback_id"
  end

  create_table "feedbacks", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "sender_id"
    t.integer "recipient_id"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "updated_at"], name: "index_feedbacks_on_recipient_id_and_updated_at"
    t.index ["sender_id", "recipient_id"], name: "index_feedbacks_on_sender_id_and_recipient_id", unique: true
    t.index ["sender_id", "updated_at"], name: "index_feedbacks_on_sender_id_and_updated_at"
  end

  create_table "language_skills", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "language_id"
    t.string "level", limit: 255
    t.index ["language_id"], name: "index_language_skills_on_language_id"
    t.index ["user_id", "language_id"], name: "index_language_skills_on_user_id_and_language_id", unique: true
    t.index ["user_id"], name: "index_language_skills_on_user_id"
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "code", limit: 2
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "body"
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_by_sender_at"
    t.datetime "deleted_by_recipient_at"
  end

  create_table "pictures", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name", limit: 255
    t.string "image", limit: 255
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.integer "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code", "country_id"], name: "index_regions_on_code_and_country_id", unique: true
    t.index ["country_id"], name: "index_regions_on_country_id"
  end

  create_table "sectorizations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "work_type_id"
    t.index ["user_id", "work_type_id"], name: "index_sectorizations_on_user_id_and_work_type_id", unique: true
    t.index ["user_id"], name: "index_sectorizations_on_user_id"
    t.index ["work_type_id"], name: "index_sectorizations_on_work_type_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255, default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "type", limit: 255
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token", limit: 255
    t.integer "karma", default: 0
    t.text "accommodation"
    t.text "skills"
    t.integer "min_stay"
    t.integer "hours_per_day"
    t.integer "days_per_week"
    t.integer "availability_mask"
    t.integer "region_id"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "admin_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "work_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
  end

end
