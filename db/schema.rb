# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_08_27_155846) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_logs", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "user_id", null: false
    t.string "action"
    t.bigint "old_status_id"
    t.bigint "new_status_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_activity_logs_on_document_id"
    t.index ["new_status_id"], name: "index_activity_logs_on_new_status_id"
    t.index ["old_status_id"], name: "index_activity_logs_on_old_status_id"
    t.index ["user_id"], name: "index_activity_logs_on_user_id"
  end

  create_table "document_tags", force: :cascade do |t|
    t.bigint "document_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_document_tags_on_document_id"
    t.index ["tag_id"], name: "index_document_tags_on_tag_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.text "content"
    t.bigint "folder_id", null: false
    t.bigint "author_id", null: false
    t.bigint "status_id", null: false
    t.bigint "scenario_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_documents_on_author_id"
    t.index ["folder_id"], name: "index_documents_on_folder_id"
    t.index ["scenario_type_id"], name: "index_documents_on_scenario_type_id"
    t.index ["status_id"], name: "index_documents_on_status_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "parent_folder_id"
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_folder_id"], name: "index_folders_on_parent_folder_id"
    t.index ["team_id"], name: "index_folders_on_team_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scenario_types", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_memberships", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "user_id", null: false
    t.datetime "joined_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "organization_id", null: false
    t.bigint "leader_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id"], name: "index_teams_on_leader_id"
    t.index ["organization_id"], name: "index_teams_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "role"
    t.bigint "organization_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activity_logs", "documents"
  add_foreign_key "activity_logs", "statuses", column: "new_status_id"
  add_foreign_key "activity_logs", "statuses", column: "old_status_id"
  add_foreign_key "activity_logs", "users"
  add_foreign_key "document_tags", "documents"
  add_foreign_key "document_tags", "tags"
  add_foreign_key "documents", "folders"
  add_foreign_key "documents", "scenario_types"
  add_foreign_key "documents", "statuses"
  add_foreign_key "documents", "users", column: "author_id"
  add_foreign_key "folders", "folders", column: "parent_folder_id"
  add_foreign_key "folders", "teams"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_memberships", "users"
  add_foreign_key "teams", "organizations"
  add_foreign_key "teams", "users", column: "leader_id"
  add_foreign_key "users", "organizations"
end
