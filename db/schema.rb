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

ActiveRecord::Schema.define(version: 20151012121127) do

  create_table "bank_accounts", force: :cascade do |t|
    t.string  "bank_name",      limit: 255
    t.string  "address",        limit: 255
    t.string  "city",           limit: 255
    t.string  "state",          limit: 255
    t.string  "zip",            limit: 255
    t.string  "country",        limit: 255
    t.string  "account_name",   limit: 255
    t.string  "account_number", limit: 255
    t.string  "currency",       limit: 255
    t.string  "routing_number", limit: 255
    t.string  "bic",            limit: 255
    t.string  "iban",           limit: 255
    t.integer "user_id",        limit: 4,   null: false
  end

  create_table "brand_payments", force: :cascade do |t|
    t.date    "billed_date"
    t.integer "amount_billed",  limit: 4, default: 0
    t.integer "status",         limit: 4, default: 0
    t.integer "transaction_id", limit: 4, default: 0
    t.integer "campaign_id",    limit: 4,             null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "text",                       limit: 255
    t.string   "headline",                   limit: 255
    t.string   "social_account_page_name",   limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "campaign_active",            limit: 1,   default: true
    t.integer  "cost",                       limit: 4,   default: 0
    t.integer  "social_account_activity_id", limit: 4,   default: 0
    t.integer  "post_type",                  limit: 4,   default: 0
    t.integer  "number_of_likes",            limit: 4,   default: 0
    t.integer  "number_of_post_reach",       limit: 4,   default: 0
    t.integer  "number_of_comments",         limit: 4,   default: 0
    t.integer  "number_of_shares",           limit: 4,   default: 0
    t.string   "card_number",                limit: 255
    t.integer  "card_expiration_month",      limit: 4
    t.integer  "card_expiration_year",       limit: 4
    t.string   "card_holder_name",           limit: 255
    t.integer  "schedule_type",              limit: 4,   default: 0
    t.integer  "status",                     limit: 4,   default: 0
    t.integer  "sender_id",                  limit: 4
    t.integer  "receiver_id",                limit: 4
    t.boolean  "starred_by_brand",           limit: 1,   default: false
    t.boolean  "starred_by_influencer",      limit: 1,   default: false
    t.boolean  "deleted_by_brand",           limit: 1,   default: false
    t.boolean  "deleted_by_influencer",      limit: 1,   default: false
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "facebook_accounts", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "account_id",          limit: 255
    t.integer  "influencer_id",       limit: 4,               null: false
    t.string   "access_token",        limit: 255,             null: false
    t.datetime "token_expires_at",                            null: false
    t.integer  "status_update_cost",  limit: 4,   default: 0
    t.integer  "profile_photo_cost",  limit: 4,   default: 0
    t.integer  "cover_photo_cost",    limit: 4,   default: 0
    t.integer  "video_post_cost",     limit: 4,   default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "number_of_followers", limit: 4
    t.integer  "daily_page_views",    limit: 4
    t.integer  "number_of_posts",     limit: 4
    t.integer  "post_reach",          limit: 4
  end

  create_table "facebooks", force: :cascade do |t|
    t.string   "uid",                 limit: 255,             null: false
    t.string   "access_token",        limit: 255,             null: false
    t.datetime "token_expires_at",                            null: false
    t.integer  "status_update_price", limit: 4,   default: 0
    t.integer  "profile_photo_price", limit: 4,   default: 0
    t.integer  "checkin_price",       limit: 4,   default: 0
    t.integer  "video_post_price",    limit: 4,   default: 0
    t.integer  "banner_photo_price",  limit: 4,   default: 0
    t.integer  "line_price",          limit: 4,   default: 0
    t.integer  "influencer_id",       limit: 4,               null: false
  end

  create_table "influencer_payments", force: :cascade do |t|
    t.date    "billed_date"
    t.integer "amount_billed",   limit: 4, default: 0
    t.integer "status",          limit: 4, default: 0
    t.integer "transaction_id",  limit: 4, default: 0
    t.integer "user_id",         limit: 4,             null: false
    t.integer "bank_account_id", limit: 4,             null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "sender_id",   limit: 4
    t.integer  "receiver_id", limit: 4
    t.integer  "campaign_id", limit: 4
    t.text     "body",        limit: 65535
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.boolean  "read",        limit: 1,     default: false
  end

  create_table "offers", force: :cascade do |t|
    t.boolean  "read",                  limit: 1
    t.integer  "sender_id",             limit: 4
    t.integer  "receiver_id",           limit: 4
    t.integer  "status",                limit: 4,   default: 0
    t.string   "message",               limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "starred_by_brand",      limit: 1,   default: false
    t.boolean  "starred_by_influencer", limit: 1,   default: false
    t.datetime "denied_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "username",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "pages", ["username"], name: "index_pages_on_username", using: :btree

  create_table "social_accounts", force: :cascade do |t|
    t.string   "provider",         limit: 255
    t.string   "uid",              limit: 255
    t.string   "access_token",     limit: 255
    t.integer  "user_id",          limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "token_expires_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: ""
    t.string   "encrypted_password",     limit: 255, default: "",   null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "image",                  limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "name",                   limit: 255
    t.string   "access_token",           limit: 255
    t.datetime "token_expires_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.boolean  "is_available",           limit: 1,   default: true
    t.string   "company_name",           limit: 255
    t.string   "company_email",          limit: 255
    t.string   "industry",               limit: 255
    t.integer  "phone",                  limit: 4
    t.string   "street_address",         limit: 255
    t.string   "landmark",               limit: 255
    t.string   "city",                   limit: 255
    t.string   "state",                  limit: 255
    t.string   "country",                limit: 255
    t.string   "zip_code",               limit: 255
    t.string   "short_bio",              limit: 255
    t.integer  "user_type",              limit: 4,   default: 0
    t.integer  "gender",                 limit: 4
    t.string   "channel_name",           limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["provider", "uid"], name: "index_users_on_provider_and_uid", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
