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

ActiveRecord::Schema.define(version: 20140419100046) do

  create_table "access_keys", force: true do |t|
    t.string   "access_token"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calenderevents", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "description"
    t.date     "startdate"
    t.date     "enddate"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "employees", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "role_id"
    t.integer  "team_id"
    t.integer  "technology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "auth_token"
    t.string   "devise_type",           default: "ios"
    t.string   "devise_token"
    t.string   "known_technology_id"
    t.integer  "badge",                 default: 0
    t.boolean  "active",                default: true
    t.date     "joining_date"
    t.date     "birthdate"
    t.string   "slug"
    t.string   "pic_url"
    t.string   "provider"
    t.string   "uid"
    t.string   "refresh_token"
    t.datetime "token_expires_at"
    t.string   "event_id_birthdate"
    t.string   "event_id_joining_date"
  end

  add_index "employees", ["role_id", "team_id"], name: "index_employees_on_role_id_and_team_id", using: :btree
  add_index "employees", ["slug"], name: "index_employees_on_slug", unique: true, using: :btree
  add_index "employees", ["team_id"], name: "index_employees_on_team_id", using: :btree

  create_table "event_series", force: true do |t|
    t.integer  "frequency",  default: 1
    t.string   "period",     default: "monthly"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.string   "title"
    t.datetime "starttime"
    t.datetime "endtime"
    t.boolean  "all_day",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "event_series_id"
  end

  add_index "events", ["event_series_id"], name: "index_events_on_event_series_id", using: :btree

  create_table "factor_guidlines", force: true do |t|
    t.string   "description"
    t.integer  "value"
    t.string   "factor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",      default: true
  end

  create_table "factors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
    t.string   "slug"
  end

  add_index "factors", ["id", "name"], name: "index_factors_on_id_and_name", using: :btree
  add_index "factors", ["name"], name: "index_factors_on_name", using: :btree

  create_table "leave_reason_categories", force: true do |t|
    t.string   "name"
    t.string   "colour",     default: "#ff0000"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
  end

  create_table "leaves", force: true do |t|
    t.date     "date_of_application"
    t.date     "date_of_approval"
    t.integer  "employee_id"
    t.date     "leave_required_from"
    t.date     "leave_required_to"
    t.string   "leave_options"
    t.boolean  "informed_to_client"
    t.string   "reason_of_leave"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                   default: 4
    t.string   "google_leave_id"
    t.integer  "leave_reason_category_id"
  end

  create_table "rating_details", force: true do |t|
    t.integer  "rating_id"
    t.integer  "rating_value"
    t.integer  "factor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", force: true do |t|
    t.date     "rating_date"
    t.integer  "employee_id"
    t.text     "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "total_rating",       default: 0.0
    t.integer  "project_manager_id"
  end

  add_index "ratings", ["employee_id"], name: "index_ratings_on_employee_id", using: :btree
  add_index "ratings", ["rating_date", "employee_id"], name: "index_ratings_on_rating_date_and_employee_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "project_manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "slug"
  end

  create_table "technologies", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
