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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20170921081710) do

  create_table "carts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "parent_id",  :null => false
    t.integer  "position",   :null => false
    t.string   "ancestor",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "customers", :force => true do |t|
    t.string   "first_name",                         :null => false
    t.string   "last_name",                          :null => false
    t.string   "user_name",                          :null => false
    t.string   "hashed_password",                    :null => false
    t.string   "salt",                               :null => false
    t.string   "email",                              :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "admin",           :default => false
  end

  create_table "line_items", :force => true do |t|
    t.integer  "product_id",                :null => false
    t.integer  "cart_id"
    t.integer  "quantity",   :default => 1
    t.integer  "order_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "street"
    t.string   "town"
    t.string   "pay_type"
    t.string   "zip"
    t.string   "phone"
    t.integer  "customer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "products", :force => true do |t|
    t.string   "title",                                     :null => false
    t.text     "description",                               :null => false
    t.string   "image_url",                                 :null => false
    t.decimal  "price",       :precision => 8, :scale => 2, :null => false
    t.integer  "category_id",                               :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
