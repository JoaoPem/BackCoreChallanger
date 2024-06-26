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

ActiveRecord::Schema.define(version: 2024_05_31_160628) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "order_order_rams", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "order_ram_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_order_rams_on_order_id"
    t.index ["order_ram_id"], name: "index_order_order_rams_on_order_ram_id"
  end

  create_table "order_rams", force: :cascade do |t|
    t.text "ram_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "processor_id"
    t.bigint "motherboard_id"
    t.bigint "video_card_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["motherboard_id"], name: "index_orders_on_motherboard_id"
    t.index ["processor_id"], name: "index_orders_on_processor_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
    t.index ["video_card_id"], name: "index_orders_on_video_card_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "specifications"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "order_order_rams", "order_rams"
  add_foreign_key "order_order_rams", "orders"
  add_foreign_key "orders", "products", column: "motherboard_id"
  add_foreign_key "orders", "products", column: "processor_id"
  add_foreign_key "orders", "products", column: "video_card_id"
  add_foreign_key "orders", "users"
  add_foreign_key "products", "categories"
end
