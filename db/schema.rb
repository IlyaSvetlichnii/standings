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

ActiveRecord::Schema.define(version: 2019_09_22_073230) do

  create_table "divisions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_matches", force: :cascade do |t|
    t.integer "tournament_id"
    t.integer "team_id"
    t.integer "enemy_team_id"
    t.integer "points"
    t.string "stage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_matches_on_team_id"
    t.index ["tournament_id"], name: "index_team_matches_on_tournament_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "title"
    t.integer "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_teams_on_division_id"
  end

  create_table "tournament_stages", force: :cascade do |t|
    t.string "title"
    t.integer "total_points"
    t.string "result"
    t.integer "tournament_id"
    t.integer "division_id"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_tournament_stages_on_division_id"
    t.index ["team_id"], name: "index_tournament_stages_on_team_id"
    t.index ["tournament_id"], name: "index_tournament_stages_on_tournament_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
