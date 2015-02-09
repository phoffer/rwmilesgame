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

ActiveRecord::Schema.define(version: 20150208021519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "current_week_id", default: 0
    t.integer  "year"
    t.integer  "status",          default: 0
    t.datetime "closes_at"
    t.integer  "count"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "players", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "name"
    t.string   "slug"
    t.integer  "goal",          default: 0
    t.float    "total",         default: 0.0
    t.integer  "status",        default: 0
    t.boolean  "captain",       default: false
    t.string   "cell_number"
    t.string   "cell_provider"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "players", ["team_id"], name: "index_players_on_team_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "player_id"
    t.integer  "week_id"
    t.integer  "score_id"
    t.float    "total"
    t.integer  "status",     default: 0
    t.datetime "posted_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "posts", ["player_id"], name: "index_posts_on_player_id", using: :btree
  add_index "posts", ["score_id"], name: "index_posts_on_score_id", using: :btree
  add_index "posts", ["week_id"], name: "index_posts_on_week_id", using: :btree

  create_table "scores", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "week_id"
    t.float    "points"
    t.float    "total"
    t.integer  "mb"
    t.integer  "po"
    t.float    "high"
    t.float    "low"
    t.float    "avg"
    t.integer  "opponent_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "scores", ["team_id"], name: "index_scores_on_team_id", using: :btree
  add_index "scores", ["week_id"], name: "index_scores_on_week_id", using: :btree

  create_table "teams", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "name"
    t.string   "slug"
    t.integer  "status",        default: 0
    t.boolean  "allstar_bonus", default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "teams", ["game_id"], name: "index_teams_on_game_id", using: :btree

  create_table "weeks", force: :cascade do |t|
    t.integer  "game_id"
    t.integer  "number"
    t.integer  "days",       default: 7
    t.integer  "count"
    t.integer  "status",     default: 0
    t.string   "thread_url"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "weeks", ["game_id"], name: "index_weeks_on_game_id", using: :btree

  add_foreign_key "players", "teams"
  add_foreign_key "posts", "players"
  add_foreign_key "posts", "scores"
  add_foreign_key "posts", "weeks"
  add_foreign_key "scores", "teams"
  add_foreign_key "scores", "weeks"
  add_foreign_key "teams", "games"
  add_foreign_key "weeks", "games"
end
