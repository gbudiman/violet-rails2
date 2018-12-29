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

ActiveRecord::Schema.define(version: 2018_12_29_080728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.string "uuid", null: false
    t.jsonb "initial_state", null: false
    t.jsonb "current_state", null: false
    t.bigint "battlefield_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battlefield_id", "uuid"], name: "index_agents_on_battlefield_id_and_uuid", unique: true
    t.index ["battlefield_id"], name: "index_agents_on_battlefield_id"
  end

  create_table "battlefields", force: :cascade do |t|
    t.bigint "seed", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
