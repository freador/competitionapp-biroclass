# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_14_171621) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.text "rules"
    t.integer "status", default: 0, null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_competitions_on_owner_id"
    t.index ["status"], name: "index_competitions_on_status"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "judge_id", null: false
    t.bigint "participant_id", null: false
    t.bigint "competition_id", null: false
    t.integer "score", default: 0, null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id"], name: "index_notes_on_competition_id"
    t.index ["judge_id", "participant_id"], name: "index_notes_on_judge_id_and_participant_id", unique: true
    t.index ["judge_id"], name: "index_notes_on_judge_id"
    t.index ["participant_id"], name: "index_notes_on_participant_id"
  end

  create_table "participants", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "competition_id", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id", "name"], name: "index_participants_on_competition_id_and_name", unique: true
    t.index ["competition_id"], name: "index_participants_on_competition_id"
    t.index ["user_id"], name: "index_participants_on_user_id"
  end

  create_table "rankings", force: :cascade do |t|
    t.bigint "participant_id", null: false
    t.bigint "competition_id", null: false
    t.decimal "total_score", precision: 5, scale: 2, default: "0.0", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["competition_id", "participant_id"], name: "index_rankings_on_competition_id_and_participant_id", unique: true
    t.index ["competition_id", "position"], name: "index_rankings_on_competition_id_and_position", unique: true
    t.index ["competition_id"], name: "index_rankings_on_competition_id"
    t.index ["participant_id"], name: "index_rankings_on_participant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.integer "role", default: 0, null: false
    t.string "invitation_token"
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "competitions", "users", column: "owner_id"
  add_foreign_key "notes", "competitions"
  add_foreign_key "notes", "participants"
  add_foreign_key "notes", "users", column: "judge_id"
  add_foreign_key "participants", "competitions"
  add_foreign_key "participants", "users"
  add_foreign_key "rankings", "competitions"
  add_foreign_key "rankings", "participants"
end
