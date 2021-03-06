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

ActiveRecord::Schema.define(version: 2021_04_22_061506) do

  create_table "fixed_shifts", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.integer "user_id", null: false
    t.datetime "clock_in", null: false
    t.datetime "clock_out", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_fixed_shifts_on_shop_id"
    t.index ["user_id"], name: "index_fixed_shifts_on_user_id"
  end

  create_table "requested_shifts", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.integer "user_id", null: false
    t.datetime "clock_in", null: false
    t.datetime "clock_out", null: false
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_requested_shifts_on_shop_id"
    t.index ["user_id"], name: "index_requested_shifts_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "shop_id", null: false
    t.string "name", null: false
    t.integer "age", null: false
    t.integer "user_id", null: false
    t.string "password_digest", null: false
    t.integer "work_status", null: false
    t.boolean "admin", default: false
    t.boolean "license", default: false
    t.boolean "rookie", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_users_on_shop_id"
  end

  add_foreign_key "fixed_shifts", "shops"
  add_foreign_key "fixed_shifts", "users"
  add_foreign_key "requested_shifts", "shops"
  add_foreign_key "requested_shifts", "users"
  add_foreign_key "users", "shops"
end
