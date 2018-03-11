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

ActiveRecord::Schema.define(version: 20180311094033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_tokens", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id"
    t.string "access_token"
    t.integer "token_type", default: 1, null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_access_tokens_on_access_token", unique: true
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "location"
    t.string "platform_uid"
    t.string "platform"
    t.string "event_url"
    t.string "group_uid"
    t.string "group_name"
    t.string "group_url"
    t.string "formatted_time"
    t.datetime "start_datetime"
    t.datetime "end_datetime"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rsvp_count", default: 0
    t.boolean "scheduled_for_recording", default: false
    t.string "esg_volunteer1"
    t.string "esg_volunteer2"
    t.string "esg_set"
    t.integer "schedule_status", default: 1
    t.index ["platform", "group_uid"], name: "index_events_on_platform_and_group_uid"
    t.index ["platform", "platform_uid"], name: "by_platform_uid", unique: true
    t.index ["scheduled_for_recording"], name: "index_events_on_scheduled_for_recording"
  end

  create_table "identities", force: :cascade do |t|
    t.string "uid"
    t.string "provider"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "avatar_url"
    t.string "access_token"
    t.string "refresh_token"
    t.string "token_secret"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "playlist_categories", force: :cascade do |t|
    t.string "title"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "playlist_items", force: :cascade do |t|
    t.bigint "playlist_id"
    t.bigint "presentation_id"
    t.integer "sort_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id"], name: "index_playlist_items_on_playlist_id"
    t.index ["presentation_id"], name: "index_playlist_items_on_presentation_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "playlist_uid"
    t.string "playlist_source"
    t.string "image"
    t.date "publish_date"
    t.integer "playlist_category_id"
    t.boolean "active", default: true
    t.string "website"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_category_id"], name: "index_playlists_on_playlist_category_id"
    t.index ["playlist_source", "playlist_uid"], name: "by_playlist_source_and_uid", unique: true
    t.index ["slug"], name: "by_slug", unique: true
  end

  create_table "presentations", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "presented_at"
    t.boolean "published", default: true
    t.string "video_source"
    t.string "video_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "view_count", default: 0
    t.string "image1"
    t.string "image2"
    t.string "image3"
    t.integer "status", default: 1
    t.index ["video_source", "video_id"], name: "by_video_source_and_id", unique: true
  end

  create_table "recordings", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "addr", null: false
    t.integer "clientid", null: false
    t.string "path"
    t.datetime "start_time", null: false
    t.datetime "end_time"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "addr", "clientid"], name: "by_name_ipaddr_and_clientid"
    t.index ["user_id"], name: "index_recordings_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "access_tokens", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "playlist_items", "playlists"
  add_foreign_key "playlist_items", "presentations"
  add_foreign_key "recordings", "users"
end
