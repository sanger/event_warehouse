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

ActiveRecord::Schema.define(version: 20151007115447) do
  create_table "event_types", force: :cascade do |t|
    t.string   "key",         limit: 255,   null: false, comment: "The identifier for the event"
    t.text     "description", limit: 65535, null: false, comment: "A description of the meaning of the event"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "event_types", ["key"], name: "index_event_types_on_key", unique: true, using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "lims_id",         limit: 255, null: false, comment: "Identifier for the originating LIMS. eg. SQSCP for Sequencesacape"
    t.uuid     "uuid",            limit: 16,  null: false, comment: "A binary encoded UUID use HEX(uuid) to retrieve the original (minus dashes)"
    t.integer  "event_type_id",   limit: 4,   null: false, comment: "References the event type"
    t.datetime "occured_at",                  null: false, comment: "The time at which the event was recorded as happening. Other timestamps record when the event entered the database"
    t.string   "user_identifier", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["event_type_id"], name: "fk_rails_75f14fef31", using: :btree
  add_index "events", ["uuid"], name: "index_events_on_uuid", unique: true, using: :btree

  create_table "metadata", force: :cascade do |t|
    t.integer  "event_id",   limit: 4,   null: false, comment: "References the event with which the metadata is associated"
    t.string   "key",        limit: 255, null: false, comment: "The metadata type"
    t.string   "value",      limit: 255,              comment: "The metadata value. NULL indicates no value was set."
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "metadata", ["event_id"], name: "fk_rails_03e584d244", using: :btree

  create_table "role_types", force: :cascade do |t|
    t.string   "key",         limit: 255,   null: false, comment: "The identifier for the role type"
    t.text     "description", limit: 65535, null: false, comment: "A description of the role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "role_types", ["key"], name: "index_role_types_on_key", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.integer  "event_id",     limit: 4, null: false, comment: "Associate with the event (what happened)"
    t.integer  "subject_id",   limit: 4, null: false, comment: "Associate with the subject (what it happened to, or what might care)"
    t.integer  "role_type_id", limit: 4, null: false, comment: "References the role_types table, describing the role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["event_id"], name: "index_roles_on_event_id", using: :btree
  add_index "roles", ["role_type_id"], name: "fk_rails_df614e5484", using: :btree
  add_index "roles", ["subject_id"], name: "index_roles_on_subject_id", using: :btree

  create_table "subject_types", force: :cascade do |t|
    t.string   "key",         limit: 255,   null: false, comment: "The identifier for the role type"
    t.text     "description", limit: 65535, null: false, comment: "A description of the subject type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subject_types", ["key"], name: "index_subject_types_on_key", unique: true, using: :btree

  create_table "subjects", force: :cascade do |t|
    t.uuid     "uuid",            limit: 16,  null: false, comment: "A binary encoded UUID use HEX(uuid) to retrieve the original (minus dashes)"
    t.string   "friendly_name",   limit: 255, null: false, comment: "A user readable identifier for the subject"
    t.integer  "subject_type_id", limit: 4,   null: false, comment: "References the event type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subjects", ["friendly_name"], name: "index_subjects_on_friendly_name", using: :btree
  add_index "subjects", ["subject_type_id"], name: "fk_rails_b7f2e355a0", using: :btree
  add_index "subjects", ["uuid"], name: "index_subjects_on_uuid", unique: true, using: :btree

  add_foreign_key "events", "event_types"
  add_foreign_key "metadata", "events"
  add_foreign_key "roles", "events"
  add_foreign_key "roles", "role_types"
  add_foreign_key "roles", "subjects"
  add_foreign_key "subjects", "subject_types"
end
