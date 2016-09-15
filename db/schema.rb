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

ActiveRecord::Schema.define(version: 20160915013254) do

  create_table "applicant_educations", force: :cascade do |t|
    t.string "education", limit: 255
  end

  create_table "applicant_employment_types", force: :cascade do |t|
    t.string "employment_type", limit: 255
  end

  create_table "applicant_experiences", force: :cascade do |t|
    t.string "experience", limit: 255
  end

  create_table "applicant_functions", force: :cascade do |t|
    t.string "function", limit: 255
  end

  create_table "applicant_industries", force: :cascade do |t|
    t.string "industry", limit: 255
  end

  create_table "applicants", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.string   "gender",     limit: 255, default: "", null: false
    t.date     "date_birth",                          null: false
    t.string   "email",      limit: 255, default: "", null: false
    t.string   "headline",   limit: 255, default: "", null: false
    t.string   "phone",      limit: 255, default: "", null: false
    t.string   "address",    limit: 255, default: "", null: false
    t.string   "photo",      limit: 255, default: "", null: false
    t.string   "resume",     limit: 255, default: "", null: false
    t.string   "status",     limit: 255, default: "", null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "educations", force: :cascade do |t|
    t.string   "name_school", limit: 255
    t.string   "field_study", limit: 255
    t.string   "degree",      limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "experiences", force: :cascade do |t|
    t.string   "name_company", limit: 255
    t.string   "industry",     limit: 255
    t.string   "title",        limit: 255
    t.string   "summary",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "jobs", force: :cascade do |t|
    t.string   "job_title",                limit: 255,   default: "", null: false
    t.string   "departement",              limit: 255,   default: "", null: false
    t.string   "job_code",                 limit: 255,   default: "", null: false
    t.string   "country",                  limit: 255,   default: "", null: false
    t.string   "state",                    limit: 255,   default: "", null: false
    t.string   "city",                     limit: 255,   default: "", null: false
    t.string   "zip_code",                 limit: 255,   default: "", null: false
    t.integer  "min_salary",               limit: 4,     default: 0,  null: false
    t.integer  "max_salary",               limit: 4,     default: 0,  null: false
    t.string   "curency",                  limit: 255,   default: "", null: false
    t.text     "job_description",          limit: 65535,              null: false
    t.text     "job_requirement",          limit: 65535,              null: false
    t.text     "benefits",                 limit: 65535,              null: false
    t.string   "aplicant_experience",      limit: 255,   default: "", null: false
    t.string   "aplicant_function",        limit: 255,   default: "", null: false
    t.string   "aplicant_employment_type", limit: 255,   default: "", null: false
    t.string   "aplicant_industry",        limit: 255,   default: "", null: false
    t.string   "aplicant_education",       limit: 255,   default: "", null: false
    t.string   "job_search_keyword",       limit: 255,   default: "", null: false
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
