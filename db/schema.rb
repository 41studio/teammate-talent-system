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

ActiveRecord::Schema.define(version: 20160914040306) do

  create_table "applicants", force: :cascade do |t|
    t.string   "name",          limit: 255, default: "", null: false
    t.string   "gender",        limit: 255, default: "", null: false
    t.date     "date_birth",                             null: false
    t.string   "email",         limit: 255, default: "", null: false
    t.string   "headline",      limit: 255, default: "", null: false
    t.string   "phone",         limit: 255, default: "", null: false
    t.string   "address",       limit: 255, default: "", null: false
    t.string   "photo",         limit: 255, default: "", null: false
    t.string   "resume",        limit: 255, default: "", null: false
    t.string   "status",        limit: 255, default: "", null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "experience_id", limit: 4
    t.integer  "education_id",  limit: 4
  end

  add_index "applicants", ["education_id"], name: "index_applicants_on_education_id", using: :btree
  add_index "applicants", ["experience_id"], name: "index_applicants_on_experience_id", using: :btree

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

  add_foreign_key "applicants", "educations"
  add_foreign_key "applicants", "experiences"
end
