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

ActiveRecord::Schema.define(version: 20140311094632) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: true do |t|
    t.string   "user_imei"
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alerts", ["board_id"], name: "index_alerts_on_board_id", using: :btree
  add_index "alerts", ["user_imei", "board_id"], name: "index_alerts_on_user_imei_and_board_id", unique: true, using: :btree
  add_index "alerts", ["user_imei"], name: "index_alerts_on_user_imei", using: :btree

  create_table "articles", force: true do |t|
    t.string   "title"
    t.string   "nickname"
    t.string   "article_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "like",               default: 0
    t.integer  "alert_count",        default: 0
    t.integer  "cached_votes_total", default: 0
    t.integer  "cached_votes_score", default: 0
    t.integer  "cached_votes_up",    default: 0
    t.integer  "cached_votes_down",  default: 0
    t.string   "imei",               default: ""
  end

  add_index "articles", ["cached_votes_down"], name: "index_articles_on_cached_votes_down", using: :btree
  add_index "articles", ["cached_votes_score"], name: "index_articles_on_cached_votes_score", using: :btree
  add_index "articles", ["cached_votes_total"], name: "index_articles_on_cached_votes_total", using: :btree
  add_index "articles", ["cached_votes_up"], name: "index_articles_on_cached_votes_up", using: :btree

  create_table "batters", force: true do |t|
    t.string   "rank"
    t.string   "player"
    t.string   "team"
    t.string   "game_count"
    t.string   "play_count"
    t.string   "bat_count"
    t.string   "hit"
    t.string   "b2"
    t.string   "b3"
    t.string   "hr"
    t.string   "hit_score"
    t.string   "own_score"
    t.string   "stolen_base"
    t.string   "dead_ball"
    t.string   "out_count"
    t.string   "heat_rate"
    t.string   "run_rate"
    t.string   "long_rate"
    t.string   "ops"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boards", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "imei"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cached_votes_total", default: 0
    t.integer  "cached_votes_score", default: 0
    t.integer  "cached_votes_up",    default: 0
    t.integer  "cached_votes_down",  default: 0
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "board_type",         default: 0
  end

  add_index "boards", ["cached_votes_down"], name: "index_boards_on_cached_votes_down", using: :btree
  add_index "boards", ["cached_votes_score"], name: "index_boards_on_cached_votes_score", using: :btree
  add_index "boards", ["cached_votes_total"], name: "index_boards_on_cached_votes_total", using: :btree
  add_index "boards", ["cached_votes_up"], name: "index_boards_on_cached_votes_up", using: :btree
  add_index "boards", ["imei"], name: "index_boards_on_imei", using: :btree

  create_table "comments", force: true do |t|
    t.string   "comment",      default: "",    null: false
    t.integer  "team_idx",                     null: false
    t.integer  "out_count",    default: -1
    t.integer  "strike",       default: -1
    t.integer  "ball",         default: -1
    t.string   "base",         default: ""
    t.string   "stage",        default: ""
    t.string   "game_id",      default: ""
    t.string   "comment_type", default: ""
    t.string   "extra_1"
    t.string   "extra_2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nickname",     default: "",    null: false
    t.boolean  "is_broadcast", default: false, null: false
    t.integer  "homescore",    default: 0
    t.integer  "awayscore",    default: 0
    t.string   "imei",         default: ""
  end

  add_index "comments", ["game_id"], name: "index_comments_on_game_id", using: :btree

  create_table "pitchers", force: true do |t|
    t.string   "rank"
    t.string   "player"
    t.string   "team"
    t.string   "game_count"
    t.string   "win"
    t.string   "lose"
    t.string   "save_point"
    t.string   "hold"
    t.string   "inning"
    t.string   "ball_count"
    t.string   "hit_count"
    t.string   "hr_count"
    t.string   "out_count"
    t.string   "dead_ball"
    t.string   "total_lost_score"
    t.string   "lost_score"
    t.string   "avg_lost_score"
    t.string   "whip"
    t.string   "qs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ranks", force: true do |t|
    t.string   "rank"
    t.string   "team"
    t.string   "game_count"
    t.string   "win"
    t.string   "defeat"
    t.string   "draw"
    t.string   "win_rate"
    t.string   "win_diff"
    t.string   "win_continue"
    t.string   "recent_game"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: true do |t|
    t.integer  "alerter_id"
    t.integer  "alerted_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["alerted_id"], name: "index_relationships_on_alerted_id", using: :btree
  add_index "relationships", ["alerter_id", "alerted_id"], name: "index_relationships_on_alerter_id_and_alerted_id", unique: true, using: :btree
  add_index "relationships", ["alerter_id"], name: "index_relationships_on_alerter_id", using: :btree

  create_table "replies", force: true do |t|
    t.string   "content"
    t.integer  "board_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "imei"
  end

  create_table "reports", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "thumbnail_url"
    t.string   "url"
    t.datetime "pub_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", force: true do |t|
    t.string   "day"
    t.string   "weak"
    t.string   "home_team"
    t.string   "home_score"
    t.string   "away_score"
    t.string   "away_team"
    t.string   "start_time"
    t.string   "tv_info"
    t.string   "station"
    t.boolean  "no_match"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "game_record_url", default: ""
    t.string   "game_relay_url",  default: ""
    t.boolean  "is_canceled",     default: false
  end

  create_table "score_lists", force: true do |t|
    t.string   "status"
    t.string   "home_team"
    t.string   "home_score"
    t.string   "away_team"
    t.string   "away_score"
    t.string   "station"
    t.string   "start_time"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_infos", force: true do |t|
    t.integer  "team_id"
    t.integer  "total_score",   default: 0
    t.integer  "total_loss",    default: 0
    t.float    "total_avg",     default: 0.0
    t.integer  "total_hit",     default: 0
    t.integer  "total_hr",      default: 0
    t.integer  "total_rb",      default: 0
    t.integer  "total_outcout", default: 0
    t.integer  "total_failure", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "total_hitter_ranks", force: true do |t|
    t.string   "profile_img", default: ""
    t.integer  "category"
    t.string   "players",     default: ""
    t.string   "values",      default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "total_ranks", force: true do |t|
    t.integer  "category"
    t.string   "players",     default: ""
    t.string   "values",      default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_img", default: ""
  end

  create_table "updates", force: true do |t|
    t.string   "content"
    t.integer  "version"
    t.string   "extra"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "nickname",             default: "",    null: false
    t.string   "imei",                 default: "",    null: false
    t.boolean  "blocked",              default: false
    t.integer  "alert_count",          default: 0
    t.integer  "nick_count",           default: 0
    t.integer  "user_type",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cached_votes_total",   default: 0
    t.integer  "cached_votes_score",   default: 0
    t.integer  "cached_votes_up",      default: 0
    t.integer  "cached_votes_down",    default: 0
    t.integer  "alerters_count",       default: 0
    t.string   "intro",                default: ""
    t.string   "profile_file_name"
    t.string   "profile_content_type"
    t.integer  "profile_file_size"
    t.datetime "profile_updated_at"
  end

  add_index "users", ["cached_votes_down"], name: "index_users_on_cached_votes_down", using: :btree
  add_index "users", ["cached_votes_score"], name: "index_users_on_cached_votes_score", using: :btree
  add_index "users", ["cached_votes_total"], name: "index_users_on_cached_votes_total", using: :btree
  add_index "users", ["cached_votes_up"], name: "index_users_on_cached_votes_up", using: :btree
  add_index "users", ["imei"], name: "index_users_on_imei", unique: true, using: :btree
  add_index "users", ["nickname"], name: "index_users_on_nickname", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_weight"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

end
