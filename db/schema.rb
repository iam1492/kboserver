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

ActiveRecord::Schema.define(:version => 20130107010037) do

  create_table "comments", :force => true do |t|
    t.string   "comment",    :default => "", :null => false
    t.integer  "team_idx",                   :null => false
    t.integer  "out_count",  :default => -1
    t.integer  "strike",     :default => -1
    t.integer  "ball",       :default => -1
    t.string   "base",       :default => ""
    t.string   "stage",      :default => ""
    t.string   "game_id",    :default => ""
    t.string   "type",       :default => ""
    t.string   "extra_1"
    t.string   "extra_2"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "nickname",   :default => "", :null => false
  end

  add_index "comments", ["game_id"], :name => "index_comments_on_game_id"

  create_table "notices", :force => true do |t|
    t.string   "content"
    t.integer  "versioncode"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "updates", :force => true do |t|
    t.string   "content"
    t.integer  "version"
    t.string   "extra"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "nickname",    :default => "",    :null => false
    t.string   "imei",        :default => "",    :null => false
    t.boolean  "blocked",     :default => false
    t.integer  "alert_count", :default => 0
    t.integer  "nick_count",  :default => 0
    t.integer  "user_type",   :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "users", ["imei"], :name => "index_users_on_imei", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true

end
