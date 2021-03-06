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

ActiveRecord::Schema.define(version: 20151217165504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "number"
    t.integer  "law_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "articles", ["law_id"], name: "index_articles_on_law_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "doc_file_file_name"
    t.string   "doc_file_content_type"
    t.integer  "doc_file_file_size"
    t.datetime "doc_file_updated_at"
    t.text     "paragraphs",            default: [],              array: true
    t.string   "name"
  end

  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "laws", force: :cascade do |t|
    t.string   "name"
    t.string   "legi_cid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "references", force: :cascade do |t|
    t.integer  "article_id"
    t.integer  "document_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "status",           default: "uptodate"
    t.integer  "paragraph_number"
    t.boolean  "tracking",         default: true
  end

  add_index "references", ["article_id"], name: "index_references_on_article_id", using: :btree
  add_index "references", ["document_id"], name: "index_references_on_document_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.integer  "article_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "state"
    t.string   "legi_id"
  end

  add_index "versions", ["article_id"], name: "index_versions_on_article_id", using: :btree

  add_foreign_key "articles", "laws"
  add_foreign_key "documents", "users"
  add_foreign_key "references", "articles"
  add_foreign_key "references", "documents"
  add_foreign_key "versions", "articles"
end
