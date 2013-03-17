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

ActiveRecord::Schema.define(:version => 20130317140443) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "nickname"
    t.string   "article_url"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "like",               :default => 0
    t.integer  "alert_count",        :default => 0
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_score", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
  end

  add_index "articles", ["cached_votes_down"], :name => "index_articles_on_cached_votes_down"
  add_index "articles", ["cached_votes_score"], :name => "index_articles_on_cached_votes_score"
  add_index "articles", ["cached_votes_total"], :name => "index_articles_on_cached_votes_total"
  add_index "articles", ["cached_votes_up"], :name => "index_articles_on_cached_votes_up"

  create_table "boards", :force => true do |t|
    t.string   "title"
    t.string   "content"
    t.string   "imei"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_score", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "board_type",         :default => 0
  end

  add_index "boards", ["cached_votes_down"], :name => "index_boards_on_cached_votes_down"
  add_index "boards", ["cached_votes_score"], :name => "index_boards_on_cached_votes_score"
  add_index "boards", ["cached_votes_total"], :name => "index_boards_on_cached_votes_total"
  add_index "boards", ["cached_votes_up"], :name => "index_boards_on_cached_votes_up"
  add_index "boards", ["imei"], :name => "index_boards_on_imei"

  create_table "comments", :force => true do |t|
    t.string   "comment",      :default => "",    :null => false
    t.integer  "team_idx",                        :null => false
    t.integer  "out_count",    :default => -1
    t.integer  "strike",       :default => -1
    t.integer  "ball",         :default => -1
    t.string   "base",         :default => ""
    t.string   "stage",        :default => ""
    t.string   "game_id",      :default => ""
    t.string   "comment_type", :default => ""
    t.string   "extra_1"
    t.string   "extra_2"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.string   "nickname",     :default => "",    :null => false
    t.boolean  "is_broadcast", :default => false, :null => false
    t.integer  "homescore",    :default => 0
    t.integer  "awayscore",    :default => 0
  end

  add_index "comments", ["game_id"], :name => "index_comments_on_game_id"

  create_table "relationships", :force => true do |t|
    t.integer  "alerter_id"
    t.integer  "alerted_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "relationships", ["alerted_id"], :name => "index_relationships_on_alerted_id"
  add_index "relationships", ["alerter_id", "alerted_id"], :name => "index_relationships_on_alerter_id_and_alerted_id", :unique => true
  add_index "relationships", ["alerter_id"], :name => "index_relationships_on_alerter_id"

  create_table "replies", :force => true do |t|
    t.string   "content"
    t.integer  "board_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "imei"
  end

  create_table "updates", :force => true do |t|
    t.string   "content"
    t.integer  "version"
    t.string   "extra"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "nickname",             :default => "",    :null => false
    t.string   "imei",                 :default => "",    :null => false
    t.boolean  "blocked",              :default => false
    t.integer  "alert_count",          :default => 0
    t.integer  "nick_count",           :default => 0
    t.integer  "user_type",            :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "cached_votes_total",   :default => 0
    t.integer  "cached_votes_score",   :default => 0
    t.integer  "cached_votes_up",      :default => 0
    t.integer  "cached_votes_down",    :default => 0
    t.integer  "alerters_count",       :default => 0
    t.string   "intro",                :default => ""
    t.string   "profile_file_name"
    t.string   "profile_content_type"
    t.integer  "profile_file_size"
    t.datetime "profile_updated_at"
  end

  add_index "users", ["cached_votes_down"], :name => "index_users_on_cached_votes_down"
  add_index "users", ["cached_votes_score"], :name => "index_users_on_cached_votes_score"
  add_index "users", ["cached_votes_total"], :name => "index_users_on_cached_votes_total"
  add_index "users", ["cached_votes_up"], :name => "index_users_on_cached_votes_up"
  add_index "users", ["imei"], :name => "index_users_on_imei", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
