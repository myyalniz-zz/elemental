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

ActiveRecord::Schema.define(version: 20161119172800) do

  create_table "audio_selectors", force: :cascade do |t|
    t.boolean  "default_selection"
    t.integer  "track"
    t.integer  "input_id"
    t.integer  "audio_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "input_processings", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "input_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "input_types", force: :cascade do |t|
    t.string   "type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inputs", force: :cascade do |t|
    t.integer  "live_event_id"
    t.string   "input_label"
    t.boolean  "loop_source"
    t.integer  "input_type"
    t.boolean  "quad"
    t.string   "uri"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "live_events", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "video_selectors", force: :cascade do |t|
    t.boolean  "default_selection"
    t.integer  "track"
    t.integer  "input_id"
    t.integer  "video_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

end
