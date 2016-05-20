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

ActiveRecord::Schema.define(version: 20160520210023) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string   "t_description"
    t.integer  "survey_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "answers_thinkers", id: false, force: :cascade do |t|
    t.integer "answer_id"
    t.integer "thinker_id"
    t.integer "sprint_id"
  end

  add_index "answers_thinkers", ["answer_id"], name: "index_answers_thinkers_on_answer_id", using: :btree
  add_index "answers_thinkers", ["sprint_id"], name: "index_answers_thinkers_on_sprint_id", using: :btree
  add_index "answers_thinkers", ["thinker_id"], name: "index_answers_thinkers_on_thinker_id", using: :btree

  create_table "assigned_roles", force: :cascade do |t|
    t.integer  "thinker_id"
    t.integer  "team_role_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assigned_roles", ["project_id"], name: "index_assigned_roles_on_project_id", using: :btree
  add_index "assigned_roles", ["team_role_id"], name: "index_assigned_roles_on_team_role_id", using: :btree
  add_index "assigned_roles", ["thinker_id"], name: "index_assigned_roles_on_thinker_id", using: :btree

  create_table "attachinary_files", force: :cascade do |t|
    t.integer  "attachinariable_id"
    t.string   "attachinariable_type"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachinary_files", ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "t_name"
    t.text     "t_description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "color"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "text"
    t.boolean  "approved"
    t.integer  "task_id"
    t.integer  "thinker_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "likes_count", default: 0
  end

  add_index "comments", ["task_id"], name: "index_comments_on_task_id", using: :btree
  add_index "comments", ["thinker_id"], name: "index_comments_on_thinker_id", using: :btree

  create_table "contributions", force: :cascade do |t|
    t.integer "project_id"
    t.integer "thinker_id"
    t.integer "intensity",  default: 0
  end

  add_index "contributions", ["project_id"], name: "index_contributions_on_project_id", using: :btree
  add_index "contributions", ["thinker_id"], name: "index_contributions_on_thinker_id", using: :btree

  create_table "countries", primary_key: "iso", force: :cascade do |t|
    t.string  "name",           null: false
    t.string  "printable_name", null: false
    t.string  "iso3"
    t.integer "numcode"
  end

  create_table "cycles", force: :cascade do |t|
    t.string   "translation_code"
    t.string   "description"
    t.integer  "days"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "dependences", force: :cascade do |t|
    t.boolean  "external",                default: false
    t.string   "url"
    t.string   "reason",     limit: 1600
    t.integer  "project_id"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "dependences", ["project_id"], name: "index_dependences_on_project_id", using: :btree

  create_table "election_polls", force: :cascade do |t|
    t.integer  "status",       default: 0
    t.integer  "project_id"
    t.integer  "team_role_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "election_polls", ["project_id"], name: "index_election_polls_on_project_id", using: :btree
  add_index "election_polls", ["team_role_id"], name: "index_election_polls_on_team_role_id", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "goals", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "project_id"
    t.integer  "thinker_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "progress"
    t.datetime "deleted_at"
  end

  add_index "goals", ["deleted_at"], name: "index_goals_on_deleted_at", using: :btree
  add_index "goals", ["project_id"], name: "index_goals_on_project_id", using: :btree
  add_index "goals", ["thinker_id"], name: "index_goals_on_thinker_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 25
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "languages_projects", id: false, force: :cascade do |t|
    t.integer "language_id"
    t.integer "project_id"
  end

  add_index "languages_projects", ["language_id"], name: "index_languages_projects_on_language_id", using: :btree
  add_index "languages_projects", ["project_id"], name: "index_languages_projects_on_project_id", using: :btree

  create_table "licenses", force: :cascade do |t|
    t.string   "name",        limit: 50
    t.string   "description", limit: 1600
    t.string   "url"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer "comment_id"
    t.integer "thinker_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "thinker_id"
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "model"
    t.integer  "model_id"
  end

  create_table "notifications_thinkers", id: false, force: :cascade do |t|
    t.integer "notification_id"
    t.integer "thinker_id"
  end

  add_index "notifications_thinkers", ["notification_id"], name: "index_notifications_thinkers_on_notification_id", using: :btree
  add_index "notifications_thinkers", ["thinker_id"], name: "index_notifications_thinkers_on_thinker_id", using: :btree

  create_table "operations", force: :cascade do |t|
    t.integer  "serial"
    t.string   "text"
    t.boolean  "done"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "operations", ["task_id"], name: "index_operations_on_task_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "title",               limit: 60
    t.string   "description",         limit: 1600
    t.integer  "minimum_team_number",              default: 2
    t.date     "release_at"
    t.string   "home_url"
    t.string   "source_code_url"
    t.string   "documentation_url"
    t.integer  "license_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "thinker_id"
    t.integer  "cycle_id"
    t.integer  "category_id"
    t.string   "slug"
    t.datetime "deleted_at"
    t.string   "main_image"
    t.string   "donate_button"
  end

  add_index "projects", ["deleted_at"], name: "index_projects_on_deleted_at", using: :btree
  add_index "projects", ["license_id"], name: "index_projects_on_license_id", using: :btree
  add_index "projects", ["slug"], name: "index_projects_on_slug", unique: true, using: :btree

  create_table "reasons", force: :cascade do |t|
    t.text     "text"
    t.integer  "comment_id"
    t.integer  "thinker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reasons", ["comment_id"], name: "index_reasons_on_comment_id", using: :btree
  add_index "reasons", ["thinker_id"], name: "index_reasons_on_thinker_id", using: :btree

  create_table "releases", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "title",       limit: 60
    t.string   "description", limit: 1600
    t.date     "end_at"
    t.float    "progress"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "version"
  end

  add_index "releases", ["project_id"], name: "index_releases_on_project_id", using: :btree

  create_table "sexes", force: :cascade do |t|
    t.string "t_name"
  end

  create_table "sprints", force: :cascade do |t|
    t.integer  "obtained"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "serial"
    t.datetime "deleted_at"
  end

  add_index "sprints", ["deleted_at"], name: "index_sprints_on_deleted_at", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.string   "translation_code"
    t.string   "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "progress_order"
  end

  create_table "surveys", force: :cascade do |t|
    t.string   "t_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.integer  "serial"
    t.string   "description"
    t.integer  "project_id"
    t.integer  "thinker_id"
    t.integer  "worker_thinker_id"
    t.integer  "status_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "title"
    t.integer  "goal_id"
    t.float    "workload"
    t.float    "standard_deviation"
    t.datetime "deleted_at"
    t.integer  "release_id"
  end

  add_index "tasks", ["deleted_at"], name: "index_tasks_on_deleted_at", using: :btree

  create_table "team_roles", force: :cascade do |t|
    t.string   "t_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "thinkers", force: :cascade do |t|
    t.string   "email",                     default: "",    null: false
    t.string   "encrypted_password",        default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "name"
    t.boolean  "admin",                     default: false
    t.string   "slug"
    t.date     "born_at"
    t.string   "photo_id"
    t.integer  "sex_id"
    t.string   "avatar"
    t.string   "country_iso"
    t.string   "encrypted_otp_secret"
    t.string   "encrypted_otp_secret_iv"
    t.string   "encrypted_otp_secret_salt"
    t.integer  "consumed_timestep"
    t.boolean  "otp_required_for_login"
    t.string   "otp_backup_codes",                                       array: true
  end

  add_index "thinkers", ["email"], name: "index_thinkers_on_email", unique: true, using: :btree
  add_index "thinkers", ["reset_password_token"], name: "index_thinkers_on_reset_password_token", unique: true, using: :btree
  add_index "thinkers", ["sex_id"], name: "index_thinkers_on_sex_id", using: :btree
  add_index "thinkers", ["slug"], name: "index_thinkers_on_slug", unique: true, using: :btree

  create_table "voters", force: :cascade do |t|
    t.integer  "election_poll_id"
    t.integer  "thinker_id"
    t.integer  "elect_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "voters", ["election_poll_id"], name: "index_voters_on_election_poll_id", using: :btree
  add_index "voters", ["thinker_id"], name: "index_voters_on_thinker_id", using: :btree

  create_table "votes", id: false, force: :cascade do |t|
    t.integer "task_id"
    t.integer "thinker_id"
    t.integer "workload_id"
  end

  add_index "votes", ["task_id"], name: "index_votes_on_task_id", using: :btree
  add_index "votes", ["thinker_id"], name: "index_votes_on_thinker_id", using: :btree
  add_index "votes", ["workload_id"], name: "index_votes_on_workload_id", using: :btree

  create_table "workloads", force: :cascade do |t|
    t.float    "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
  end

end
