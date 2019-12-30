# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_28_033600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calculators", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.string "name"
    t.string "streak_holder"
    t.index ["user_id"], name: "index_calculators_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.decimal "ratio"
    t.decimal "luck"
    t.integer "wins"
    t.integer "losses"
    t.decimal "luckwins"
    t.decimal "lucklosses"
    t.integer "one_to_three_wins"
    t.integer "three_to_one_wins"
    t.integer "streak"
    t.integer "streak_count"
    t.bigint "calculator_id"
    t.json "stats"
    t.index ["calculator_id"], name: "index_players_on_calculator_id"
  end

  create_table "rolls", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "player1"
    t.string "player2"
    t.string "die1"
    t.string "die2"
    t.bigint "calculator_id"
    t.string "attacker"
    t.string "defender"
    t.string "winner"
    t.string "ratio"
    t.integer "number"
    t.index ["calculator_id"], name: "index_rolls_on_calculator_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "password_digest"
  end

end
