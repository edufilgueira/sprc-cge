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

ActiveRecord::Schema.define(version: 20220426180649) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "answer_templates", force: :cascade do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_answer_templates_on_user_id", using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "answer_type"
    t.integer  "answer_scope"
    t.integer  "status"
    t.integer  "classification"
    t.text     "description"
    t.string   "certificate_id"
    t.string   "certificate_filename"
    t.integer  "version",              default: 0, null: false
    t.datetime "deleted_at"
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "original_description"
    t.integer  "deadline"
    t.integer  "sectoral_deadline"
    t.index ["deleted_at"], name: "index_answers_on_deleted_at", using: :btree
    t.index ["ticket_id"], name: "index_answers_on_ticket_id", using: :btree
    t.index ["user_id"], name: "index_answers_on_user_id", using: :btree
  end

  create_table "answers_aud", id: :bigserial, force: :cascade do |t|
    t.integer  "id_answers"
    t.integer  "answer_type"
    t.integer  "answer_scope"
    t.integer  "status"
    t.integer  "classification"
    t.text     "description"
    t.string   "certificate_id"
    t.string   "certificate_filename"
    t.datetime "deleted_at"
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "original_description"
    t.integer  "deadline"
    t.integer  "sectoral_deadline"
    t.datetime "data_operacao_aud"
    t.string   "operacao_aud",         limit: 25
    t.string   "usuario_aud",          limit: 255
  end

  create_table "attachments", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "document_id"
    t.string   "document_filename"
    t.string   "attachmentable_type"
    t.integer  "attachmentable_id"
    t.date     "imported_at"
    t.string   "title"
    t.index ["attachmentable_type", "attachmentable_id"], name: "index_attachments_on_attachmentable_type_and_attachmentable_id", using: :btree
  end

  create_table "attendance_evaluations", force: :cascade do |t|
    t.integer  "clarity"
    t.integer  "content"
    t.integer  "wording"
    t.integer  "kindness"
    t.float    "average"
    t.text     "comment"
    t.integer  "ticket_id"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "classification"
    t.integer  "quality"
    t.integer  "treatment"
    t.integer  "textual_structure"
    t.datetime "deleted_at"
    t.index ["created_by_id"], name: "index_attendance_evaluations_on_created_by_id", using: :btree
    t.index ["deleted_at"], name: "index_attendance_evaluations_on_deleted_at", using: :btree
    t.index ["ticket_id"], name: "index_attendance_evaluations_on_ticket_id", using: :btree
    t.index ["updated_by_id"], name: "index_attendance_evaluations_on_updated_by_id", using: :btree
  end

  create_table "attendance_organ_subnets", force: :cascade do |t|
    t.integer  "attendance_id",  null: false
    t.integer  "organ_id"
    t.integer  "subnet_id"
    t.boolean  "unknown_subnet"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["attendance_id"], name: "index_attendance_organ_subnets_on_attendance_id", using: :btree
    t.index ["organ_id"], name: "index_attendance_organ_subnets_on_organ_id", using: :btree
    t.index ["subnet_id"], name: "index_attendance_organ_subnets_on_subnet_id", using: :btree
  end

  create_table "attendance_reports", force: :cascade do |t|
    t.string   "title"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "user_id"
    t.text     "filters"
    t.integer  "status"
    t.integer  "processed"
    t.integer  "total_to_process"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_attendance_reports_on_user_id", using: :btree
  end

  create_table "attendance_responses", force: :cascade do |t|
    t.text     "description",   null: false
    t.integer  "response_type", null: false
    t.integer  "ticket_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["ticket_id"], name: "index_attendance_responses_on_ticket_id", using: :btree
  end

  create_table "attendances", force: :cascade do |t|
    t.integer  "protocol",      default: -> { "nextval('protocol_seq'::regclass)" }
    t.integer  "ticket_id"
    t.integer  "service_type"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.text     "answer"
    t.boolean  "answered",      default: false
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.boolean  "unknown_organ"
    t.index ["created_by_id"], name: "index_attendances_on_created_by_id", using: :btree
    t.index ["deleted_at"], name: "index_attendances_on_deleted_at", using: :btree
    t.index ["protocol"], name: "index_attendances_on_protocol", using: :btree
    t.index ["service_type"], name: "index_attendances_on_service_type", using: :btree
    t.index ["ticket_id"], name: "index_attendances_on_ticket_id", using: :btree
    t.index ["updated_by_id"], name: "index_attendances_on_updated_by_id", using: :btree
  end

  create_table "authentication_tokens", force: :cascade do |t|
    t.string   "body"
    t.integer  "user_id"
    t.datetime "last_used_at"
    t.string   "ip_address"
    t.string   "user_agent"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_authentication_tokens_on_user_id", using: :btree
  end

  create_table "budget_programs", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "other_organs", default: false
    t.integer  "theme_id"
    t.datetime "disabled_at"
    t.integer  "organ_id"
    t.integer  "subnet_id"
    t.index ["deleted_at"], name: "index_budget_programs_on_deleted_at", using: :btree
    t.index ["name"], name: "index_budget_programs_on_name", using: :btree
    t.index ["organ_id"], name: "index_budget_programs_on_organ_id", using: :btree
    t.index ["subnet_id"], name: "index_budget_programs_on_subnet_id", using: :btree
    t.index ["theme_id"], name: "index_budget_programs_on_theme_id", using: :btree
  end

  create_table "cities", force: :cascade do |t|
    t.integer "code",          null: false
    t.string  "name",          null: false
    t.integer "state_id",      null: false
    t.integer "ppa_region_id"
    t.index ["state_id"], name: "index_cities_on_state_id", using: :btree
  end

  create_table "citizen_comments", force: :cascade do |t|
    t.text     "description", null: false
    t.integer  "ticket_id",   null: false
    t.integer  "user_id",     null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["ticket_id"], name: "index_citizen_comments_on_ticket_id", using: :btree
    t.index ["user_id"], name: "index_citizen_comments_on_user_id", using: :btree
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_id",                      null: false
    t.string   "data_filename",                null: false
    t.integer  "data_size"
    t.string   "data_content_type"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type", using: :btree
  end

  create_table "classifications", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "topic_id"
    t.integer  "subtopic_id"
    t.integer  "department_id"
    t.integer  "sub_department_id"
    t.integer  "budget_program_id"
    t.integer  "service_type_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "other_organs",      default: false
    t.datetime "deleted_at"
    t.index ["budget_program_id"], name: "index_classifications_on_budget_program_id", using: :btree
    t.index ["deleted_at"], name: "index_classifications_on_deleted_at", using: :btree
    t.index ["department_id"], name: "index_classifications_on_department_id", using: :btree
    t.index ["service_type_id"], name: "index_classifications_on_service_type_id", using: :btree
    t.index ["sub_department_id"], name: "index_classifications_on_sub_department_id", using: :btree
    t.index ["subtopic_id"], name: "index_classifications_on_subtopic_id", using: :btree
    t.index ["ticket_id"], name: "index_classifications_on_ticket_id", using: :btree
    t.index ["topic_id"], name: "index_classifications_on_topic_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "description"
    t.datetime "deleted_at"
    t.string   "commentable_type"
    t.integer  "commentable_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "scope",            default: 1, null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.index ["author_type", "author_id"], name: "index_comments_on_author_type_and_author_id", using: :btree
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id", using: :btree
    t.index ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
    t.index ["scope"], name: "index_comments_on_scope", using: :btree
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "organ_id"
    t.string   "acronym"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "disabled_at"
    t.integer  "subnet_id"
    t.index ["deleted_at"], name: "index_departments_on_deleted_at", using: :btree
    t.index ["name"], name: "index_departments_on_name", using: :btree
    t.index ["organ_id"], name: "index_departments_on_organ_id", using: :btree
    t.index ["subnet_id"], name: "index_departments_on_subnet_id", using: :btree
  end

  create_table "evaluation_exports", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.text     "filters"
    t.integer  "status"
    t.integer  "processed"
    t.integer  "total_to_process"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "total"
    t.string   "filename"
    t.index ["user_id"], name: "index_evaluation_exports_on_user_id", using: :btree
  end

  create_table "evaluations", force: :cascade do |t|
    t.integer  "question_01_a"
    t.integer  "question_01_b"
    t.integer  "question_01_c"
    t.integer  "question_01_d"
    t.integer  "question_02"
    t.integer  "question_03"
    t.string   "question_04"
    t.float    "average"
    t.integer  "answer_id"
    t.integer  "evaluation_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "question_05"
    t.index ["answer_id"], name: "index_evaluations_on_answer_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.datetime "starts_at"
    t.string   "category"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "extension_users", force: :cascade do |t|
    t.integer  "extension_id"
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["extension_id"], name: "index_extension_users_on_extension_id", using: :btree
    t.index ["token"], name: "index_extension_users_on_token", using: :btree
    t.index ["user_id"], name: "index_extension_users_on_user_id", using: :btree
  end

  create_table "extensions", force: :cascade do |t|
    t.text     "description"
    t.string   "email"
    t.integer  "status",               default: 0
    t.datetime "deleted_at"
    t.integer  "ticket_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "ticket_department_id"
    t.integer  "solicitation",         default: 1
    t.index ["deleted_at"], name: "index_extensions_on_deleted_at", using: :btree
    t.index ["status"], name: "index_extensions_on_status", using: :btree
    t.index ["ticket_department_id"], name: "index_extensions_on_ticket_department_id", using: :btree
    t.index ["ticket_id"], name: "index_extensions_on_ticket_id", using: :btree
  end

  create_table "gross_exports", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "filters"
    t.integer  "status"
    t.string   "filename"
    t.integer  "processed"
    t.integer  "total"
    t.integer  "total_to_process"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "load_creator_info", default: false
    t.boolean  "load_description",  default: false
    t.boolean  "load_answers",      default: false
    t.index ["user_id"], name: "index_gross_exports_on_user_id", using: :btree
  end

  create_table "holidays", force: :cascade do |t|
    t.string   "title"
    t.integer  "day"
    t.integer  "month"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day", "month"], name: "index_holidays_on_day_and_month", using: :btree
    t.index ["deleted_at"], name: "index_holidays_on_deleted_at", using: :btree
  end

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.string  "unsubscriber_type"
    t.integer "unsubscriber_id"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id", using: :btree
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type", using: :btree
  end

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    default: ""
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              default: ""
    t.string   "sender_type"
    t.integer  "sender_id"
    t.integer  "conversation_id"
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.string   "notified_object_type"
    t.integer  "notified_object_id"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id", using: :btree
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type", using: :btree
    t.index ["notified_object_type", "notified_object_id"], name: "mailboxer_notifications_notified_object", using: :btree
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type", using: :btree
    t.index ["type"], name: "index_mailboxer_notifications_on_type", using: :btree
  end

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.string   "receiver_type"
    t.integer  "receiver_id"
    t.integer  "notification_id",                            null: false
    t.boolean  "is_read",                    default: false
    t.boolean  "trashed",                    default: false
    t.boolean  "deleted",                    default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.boolean  "is_delivered",               default: false
    t.string   "delivery_method"
    t.string   "message_id"
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id", using: :btree
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type", using: :btree
  end

  create_table "mobile_apps", force: :cascade do |t|
    t.string  "name",             null: false
    t.text    "description"
    t.string  "link_apple_store"
    t.string  "link_google_play"
    t.boolean "official"
    t.string  "icon_id"
    t.string  "icon_filename"
  end

  create_table "mobile_apps_tags", force: :cascade do |t|
    t.integer "mobile_app_id"
    t.integer "mobile_tag_id"
    t.index ["mobile_app_id"], name: "index_mobile_apps_tags_on_mobile_app_id", using: :btree
    t.index ["mobile_tag_id"], name: "index_mobile_apps_tags_on_mobile_tag_id", using: :btree
  end

  create_table "mobile_tags", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "occurrences", force: :cascade do |t|
    t.text     "description"
    t.integer  "attendance_id"
    t.datetime "deleted_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "created_by_id"
    t.index ["attendance_id"], name: "index_occurrences_on_attendance_id", using: :btree
    t.index ["created_by_id"], name: "index_occurrences_on_created_by_id", using: :btree
    t.index ["deleted_at"], name: "index_occurrences_on_deleted_at", using: :btree
  end

  create_table "ombudsmen", force: :cascade do |t|
    t.string   "title"
    t.string   "contact_name"
    t.string   "phone"
    t.string   "email"
    t.string   "address"
    t.string   "operating_hours"
    t.integer  "kind"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "organ_associations", force: :cascade do |t|
    t.integer  "organ_id"
    t.integer  "organ_association_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_organ_associations_on_deleted_at", using: :btree
    t.index ["organ_id"], name: "index_organ_associations_on_organ_id", using: :btree
  end

  create_table "organs", force: :cascade do |t|
    t.string   "acronym"
    t.string   "name"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "code"
    t.boolean  "subnet"
    t.boolean  "ignore_cge_validation"
    t.datetime "disabled_at"
    t.string   "type"
    t.index ["acronym"], name: "index_organs_on_acronym", using: :btree
    t.index ["code"], name: "index_organs_on_code", using: :btree
    t.index ["deleted_at"], name: "index_organs_on_deleted_at", using: :btree
    t.index ["subnet"], name: "index_organs_on_subnet", using: :btree
    t.index ["type"], name: "index_organs_on_type", using: :btree
  end

  create_table "ouvidoria_programa", id: false, force: :cascade do |t|
    t.serial  "id",                                null: false
    t.string  "protocolo",             limit: 100
    t.string  "orgao",                 limit: 100
    t.string  "programa_orcamentario", limit: 200
    t.bigint  "programa_id"
    t.bigint  "orgao_id"
    t.integer "protocol"
  end

  create_table "page_attachment_translations", force: :cascade do |t|
    t.integer  "page_attachment_id", null: false
    t.string   "locale",             null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "title"
    t.index ["locale"], name: "index_page_attachment_translations_on_locale", using: :btree
    t.index ["page_attachment_id"], name: "index_page_attachment_translations_on_page_attachment_id", using: :btree
  end

  create_table "page_attachments", force: :cascade do |t|
    t.integer  "page_id"
    t.string   "document_id"
    t.string   "document_filename"
    t.date     "imported_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["page_id"], name: "index_page_attachments_on_page_id", using: :btree
  end

  create_table "page_chart_translations", force: :cascade do |t|
    t.integer  "page_chart_id", null: false
    t.string   "locale",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "title"
    t.text     "description"
    t.string   "unit"
    t.index ["locale"], name: "index_page_chart_translations_on_locale", using: :btree
    t.index ["page_chart_id"], name: "index_page_chart_translations_on_page_chart_id", using: :btree
  end

  create_table "page_charts", force: :cascade do |t|
    t.integer  "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_id"], name: "index_page_charts_on_page_id", using: :btree
  end

  create_table "page_series_data", force: :cascade do |t|
    t.integer  "series_type"
    t.integer  "page_chart_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["page_chart_id"], name: "index_page_series_data_on_page_chart_id", using: :btree
  end

  create_table "page_series_datum_translations", force: :cascade do |t|
    t.integer  "page_series_datum_id", null: false
    t.string   "locale",               null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "title"
    t.index ["locale"], name: "index_page_series_datum_translations_on_locale", using: :btree
    t.index ["page_series_datum_id"], name: "index_page_series_datum_translations_on_page_series_datum_id", using: :btree
  end

  create_table "page_series_item_translations", force: :cascade do |t|
    t.integer  "page_series_item_id", null: false
    t.string   "locale",              null: false
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "title"
    t.index ["locale"], name: "index_page_series_item_translations_on_locale", using: :btree
    t.index ["page_series_item_id"], name: "index_page_series_item_translations_on_page_series_item_id", using: :btree
  end

  create_table "page_series_items", force: :cascade do |t|
    t.decimal  "value"
    t.integer  "page_series_datum_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["page_series_datum_id"], name: "index_page_series_items_on_page_series_datum_id", using: :btree
  end

  create_table "page_translations", force: :cascade do |t|
    t.integer  "page_id",       null: false
    t.string   "locale",        null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "title"
    t.string   "menu_title"
    t.text     "content"
    t.text     "cached_charts"
    t.index ["locale"], name: "index_page_translations_on_locale", using: :btree
    t.index ["page_id"], name: "index_page_translations_on_page_id", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.string   "slug"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "parent_id"
    t.integer  "status"
    t.boolean  "show_survey"
    t.boolean  "big_display", default: false
    t.index ["parent_id"], name: "index_pages_on_parent_id", using: :btree
    t.index ["slug"], name: "index_pages_on_slug", unique: true, using: :btree
  end

  create_table "ppa_administrators", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "cpf",                                 null: false
    t.datetime "deleted_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["confirmation_token"], name: "index_ppa_administrators_on_confirmation_token", unique: true, using: :btree
    t.index ["cpf", "deleted_at"], name: "index_ppa_administrators_on_cpf_and_deleted_at", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_ppa_administrators_on_deleted_at", using: :btree
    t.index ["email", "deleted_at"], name: "index_ppa_administrators_on_email_and_deleted_at", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_ppa_administrators_on_reset_password_token", unique: true, using: :btree
  end

  create_table "ppa_annual_regional_initiative_budgets", force: :cascade do |t|
    t.integer  "regional_initiative_id",                          null: false
    t.integer  "period"
    t.decimal  "expected",               precision: 15, scale: 2
    t.decimal  "actual",                 precision: 15, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["regional_initiative_id", "period"], name: "index_ppa_annreg_initiative_budgets_uniqueness", unique: true, using: :btree
    t.index ["regional_initiative_id"], name: "index_ppa_annreg_initiative_budgets_on_regional_initiative_id", using: :btree
  end

  create_table "ppa_annual_regional_initiatives", force: :cascade do |t|
    t.integer  "initiative_id", null: false
    t.integer  "region_id",     null: false
    t.integer  "year",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["initiative_id", "region_id", "year"], name: "index_ppa_regional_initiatives_uniqueness", unique: true, using: :btree
    t.index ["initiative_id"], name: "index_ppa_annual_regional_initiatives_on_initiative_id", using: :btree
    t.index ["region_id"], name: "index_ppa_annual_regional_initiatives_on_region_id", using: :btree
    t.index ["year"], name: "index_ppa_annual_regional_initiatives_on_year", using: :btree
  end

  create_table "ppa_annual_regional_product_goals", force: :cascade do |t|
    t.integer  "regional_product_id",                          null: false
    t.integer  "period"
    t.decimal  "expected",            precision: 15, scale: 2
    t.decimal  "actual",              precision: 15, scale: 2
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["regional_product_id", "period"], name: "index_ppa_annreg_product_goals_uniqueness", unique: true, using: :btree
    t.index ["regional_product_id"], name: "index_ppa_annual_regional_product_goals_on_regional_product_id", using: :btree
  end

  create_table "ppa_annual_regional_products", force: :cascade do |t|
    t.integer  "product_id", null: false
    t.integer  "region_id",  null: false
    t.integer  "year",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "region_id", "year"], name: "index_ppa_annreg_products_uniqueness", unique: true, using: :btree
    t.index ["product_id"], name: "index_ppa_annual_regional_products_on_product_id", using: :btree
    t.index ["region_id"], name: "index_ppa_annual_regional_products_on_region_id", using: :btree
    t.index ["year"], name: "index_ppa_annual_regional_products_on_year", using: :btree
  end

  create_table "ppa_annual_regional_strategies", force: :cascade do |t|
    t.integer  "strategy_id", null: false
    t.integer  "region_id",   null: false
    t.integer  "year",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["region_id"], name: "index_ppa_annual_regional_strategies_on_region_id", using: :btree
    t.index ["strategy_id", "region_id", "year"], name: "index_ppa_regional_strategies_uniqueness", unique: true, using: :btree
    t.index ["strategy_id"], name: "index_ppa_annual_regional_strategies_on_strategy_id", using: :btree
    t.index ["year"], name: "index_ppa_annual_regional_strategies_on_year", using: :btree
  end

  create_table "ppa_attachments", force: :cascade do |t|
    t.string   "type",                    null: false
    t.string   "uploadable_type",         null: false
    t.integer  "uploadable_id",           null: false
    t.string   "attachment_id",           null: false
    t.string   "attachment_filename",     null: false
    t.string   "attachment_content_type", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "ppa_axes", force: :cascade do |t|
    t.string   "code",       null: false
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "plan_id"
    t.integer  "isn"
  end

  create_table "ppa_biennial_regional_initiative_budgets", force: :cascade do |t|
    t.integer  "regional_initiative_id",                          null: false
    t.decimal  "expected",               precision: 15, scale: 2
    t.decimal  "actual",                 precision: 15, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["regional_initiative_id"], name: "index_ppa_biennreg_initiative_budgets_on_regional_initiative_id", unique: true, using: :btree
  end

  create_table "ppa_biennial_regional_initiatives", force: :cascade do |t|
    t.integer  "initiative_id", null: false
    t.integer  "region_id",     null: false
    t.integer  "start_year",    null: false
    t.integer  "end_year",      null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "name"
    t.index ["end_year"], name: "index_ppa_biennial_regional_initiatives_on_end_year", using: :btree
    t.index ["initiative_id", "region_id", "start_year"], name: "index_ppa_biennreg_initiatives_uniqueness", unique: true, using: :btree
    t.index ["initiative_id"], name: "index_ppa_biennial_regional_initiatives_on_initiative_id", using: :btree
    t.index ["region_id"], name: "index_ppa_biennial_regional_initiatives_on_region_id", using: :btree
    t.index ["start_year"], name: "index_ppa_biennial_regional_initiatives_on_start_year", using: :btree
  end

  create_table "ppa_biennial_regional_product_goals", force: :cascade do |t|
    t.integer  "regional_product_id",                          null: false
    t.decimal  "expected",            precision: 15, scale: 2
    t.decimal  "actual",              precision: 15, scale: 2
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["regional_product_id"], name: "index_ppa_biennreg_product_goals_on_regional_product_id", unique: true, using: :btree
  end

  create_table "ppa_biennial_regional_products", force: :cascade do |t|
    t.integer  "product_id", null: false
    t.integer  "region_id",  null: false
    t.integer  "start_year", null: false
    t.integer  "end_year",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_year"], name: "index_ppa_biennial_regional_products_on_end_year", using: :btree
    t.index ["product_id", "region_id", "start_year"], name: "index_ppa_biennreg_products_uniqueness", unique: true, using: :btree
    t.index ["product_id"], name: "index_ppa_biennial_regional_products_on_product_id", using: :btree
    t.index ["region_id"], name: "index_ppa_biennial_regional_products_on_region_id", using: :btree
    t.index ["start_year"], name: "index_ppa_biennial_regional_products_on_start_year", using: :btree
  end

  create_table "ppa_biennial_regional_strategies", force: :cascade do |t|
    t.integer  "strategy_id",       null: false
    t.integer  "region_id",         null: false
    t.integer  "start_year",        null: false
    t.integer  "end_year",          null: false
    t.integer  "priority"
    t.integer  "priority_index"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "initiatives_count"
    t.integer  "products_count"
    t.index ["end_year"], name: "index_ppa_biennial_regional_strategies_on_end_year", using: :btree
    t.index ["priority"], name: "index_ppa_biennial_regional_strategies_on_priority", using: :btree
    t.index ["priority_index"], name: "index_ppa_biennial_regional_strategies_on_priority_index", using: :btree
    t.index ["region_id"], name: "index_ppa_biennial_regional_strategies_on_region_id", using: :btree
    t.index ["start_year"], name: "index_ppa_biennial_regional_strategies_on_start_year", using: :btree
    t.index ["strategy_id", "region_id", "start_year"], name: "index_ppa_biennreg_strategies_uniqueness", unique: true, using: :btree
    t.index ["strategy_id"], name: "index_ppa_biennial_regional_strategies_on_strategy_id", using: :btree
  end

  create_table "ppa_initiative_strategies", force: :cascade do |t|
    t.integer  "initiative_id", null: false
    t.integer  "strategy_id",   null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["initiative_id", "strategy_id"], name: "index_ppa_initiatives_contributions_uniqueness", unique: true, using: :btree
    t.index ["initiative_id", "strategy_id"], name: "ppa_initiative_contributions_on_init_id_strat_id", unique: true, using: :btree
  end

  create_table "ppa_initiatives", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code",       null: false
    t.index ["code"], name: "index_ppa_initiatives_on_code", unique: true, using: :btree
  end

  create_table "ppa_interactions", force: :cascade do |t|
    t.integer  "user_id",                        null: false
    t.string   "type",                           null: false
    t.string   "interactable_type",              null: false
    t.integer  "interactable_id",                null: false
    t.jsonb    "data",              default: {}
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["interactable_type", "interactable_id"], name: "index_ppa_interactions_on_interactable_type_and_interactable_id", using: :btree
    t.index ["user_id"], name: "index_ppa_interactions_on_user_id", using: :btree
  end

  create_table "ppa_objective_themes", force: :cascade do |t|
    t.integer  "objective_id", null: false
    t.integer  "theme_id",     null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "region_id"
    t.index ["objective_id", "theme_id", "region_id"], name: "index_ppa_objective_themes_region_uniqueness", unique: true, using: :btree
  end

  create_table "ppa_objectives", force: :cascade do |t|
    t.string   "code",        null: false
    t.string   "name",        null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "isn"
    t.integer  "region_id"
    t.datetime "disabled_at"
    t.index ["region_id"], name: "index_ppa_objectives_on_region_id", using: :btree
  end

  create_table "ppa_plans", force: :cascade do |t|
    t.integer  "start_year", null: false
    t.integer  "end_year",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "status"
  end

  create_table "ppa_problem_situations", force: :cascade do |t|
    t.datetime "dth_registro"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "isn_solucao_problema"
    t.integer  "theme_id"
    t.integer  "axis_id"
    t.integer  "region_id"
    t.integer  "situation_id"
    t.index ["axis_id"], name: "index_ppa_problem_situations_on_axis_id", using: :btree
    t.index ["region_id"], name: "index_ppa_problem_situations_on_region_id", using: :btree
    t.index ["situation_id"], name: "index_ppa_problem_situations_on_situation_id", using: :btree
    t.index ["theme_id"], name: "index_ppa_problem_situations_on_theme_id", using: :btree
  end

  create_table "ppa_products", force: :cascade do |t|
    t.integer  "initiative_id", null: false
    t.string   "name",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "code",          null: false
    t.index ["code"], name: "index_ppa_products_on_code", unique: true, using: :btree
    t.index ["initiative_id"], name: "index_ppa_products_on_initiative_id", using: :btree
  end

  create_table "ppa_proposal_themes", force: :cascade do |t|
    t.date     "start_in",   null: false
    t.date     "end_in",     null: false
    t.integer  "plan_id",    null: false
    t.integer  "region_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_ppa_proposal_themes_on_plan_id", using: :btree
    t.index ["region_id"], name: "index_ppa_proposal_themes_on_region_id", using: :btree
  end

  create_table "ppa_proposals", force: :cascade do |t|
    t.integer  "plan_id",                    null: false
    t.integer  "objective_id"
    t.string   "strategy"
    t.text     "justification"
    t.integer  "comments_count", default: 0
    t.integer  "votes_count",    default: 0
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "theme_id",                   null: false
    t.integer  "user_id",                    null: false
    t.integer  "city_id"
    t.integer  "region_id",                  null: false
    t.index ["objective_id"], name: "index_ppa_proposals_on_objective_id", using: :btree
    t.index ["plan_id"], name: "index_ppa_proposals_on_plan_id", using: :btree
  end

  create_table "ppa_regional_initiative_budgets", force: :cascade do |t|
    t.integer  "regional_initiative_id",                          null: false
    t.decimal  "expected",               precision: 15, scale: 2
    t.decimal  "actual",                 precision: 15, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.index ["regional_initiative_id"], name: "index_ppa_regional_initiative_budgets_on_regional_initiative_id", using: :btree
    t.index ["regional_initiative_id"], name: "index_ppa_regional_initiative_budgets_uniqueness", unique: true, using: :btree
  end

  create_table "ppa_regional_initiatives", force: :cascade do |t|
    t.integer  "initiative_id", null: false
    t.integer  "region_id",     null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["initiative_id", "region_id"], name: "index_ppa_regional_initiatives_on_initiative_id_and_region_id", unique: true, using: :btree
    t.index ["initiative_id"], name: "index_ppa_regional_initiatives_on_initiative_id", using: :btree
    t.index ["region_id"], name: "index_ppa_regional_initiatives_on_region_id", using: :btree
  end

  create_table "ppa_regional_product_goals", force: :cascade do |t|
    t.integer  "regional_product_id",                          null: false
    t.decimal  "expected",            precision: 15, scale: 2
    t.decimal  "actual",              precision: 15, scale: 2
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["regional_product_id"], name: "index_ppa_regional_product_goals_on_regional_product_id", using: :btree
    t.index ["regional_product_id"], name: "index_ppa_regional_product_goals_uniqueness", unique: true, using: :btree
  end

  create_table "ppa_regional_products", force: :cascade do |t|
    t.integer  "product_id", null: false
    t.integer  "region_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "region_id"], name: "index_ppa_regional_products_on_product_id_and_region_id", unique: true, using: :btree
    t.index ["product_id"], name: "index_ppa_regional_products_on_product_id", using: :btree
    t.index ["region_id"], name: "index_ppa_regional_products_on_region_id", using: :btree
  end

  create_table "ppa_regions", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code",       null: false
    t.integer  "isn"
    t.index ["code"], name: "index_ppa_regions_on_code", unique: true, using: :btree
  end

  create_table "ppa_revision_evaluations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.integer  "question1"
    t.integer  "question2"
    t.integer  "question3"
    t.integer  "question4"
    t.integer  "question5"
    t.integer  "question6"
    t.integer  "question7"
    t.integer  "question8"
    t.integer  "question9"
    t.integer  "question10"
    t.text     "observation"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["plan_id"], name: "index_ppa_revision_evaluations_on_plan_id", using: :btree
    t.index ["user_id"], name: "index_ppa_revision_evaluations_on_user_id", using: :btree
  end

  create_table "ppa_revision_participant_profiles", force: :cascade do |t|
    t.integer  "age"
    t.integer  "genre"
    t.integer  "breed"
    t.integer  "ethnic_group"
    t.integer  "educational_level"
    t.integer  "family_income"
    t.integer  "representative"
    t.string   "representative_description"
    t.string   "collegiate"
    t.boolean  "other_ppa_participation"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "sexual_orientation"
    t.integer  "deficiency"
    t.string   "other_deficiency"
    t.string   "other_sexual_orientation"
    t.string   "other_genre"
    t.integer  "user_id"
    t.index ["user_id"], name: "index_ppa_revision_participant_profiles_on_user_id", using: :btree
  end

  create_table "ppa_revision_prioritization_region_themes", force: :cascade do |t|
    t.integer "theme_id"
    t.integer "region_id"
    t.integer "prioritization_id"
    t.index ["prioritization_id"], name: "index_ppa_revision_priorization_r_t_prioritization_id", using: :btree
    t.index ["region_id"], name: "index_ppa_revision_priorization_r_t_region_id", using: :btree
    t.index ["theme_id"], name: "index_ppa_revision_priorization_r_t_theme_id", using: :btree
  end

  create_table "ppa_revision_prioritization_regional_strategies", force: :cascade do |t|
    t.integer  "strategy_id"
    t.boolean  "priority"
    t.integer  "region_theme_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["region_theme_id"], name: "index_ppa_revision_prioritization_rs_on_region_theme_id", using: :btree
    t.index ["strategy_id"], name: "index_ppa_revision_prioritization_rs_on_strategy_id", using: :btree
  end

  create_table "ppa_revision_prioritizations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "plan_id"
    t.index ["plan_id"], name: "index_ppa_revision_prioritizations_on_plan_id", using: :btree
    t.index ["user_id"], name: "index_ppa_revision_prioritizations_on_user_id", using: :btree
  end

  create_table "ppa_revision_review_new_problem_situations", force: :cascade do |t|
    t.text     "description"
    t.integer  "city_id"
    t.integer  "region_theme_id"
    t.datetime "created_at",      default: -> { "now()" }, null: false
    t.datetime "updated_at",      default: -> { "now()" }, null: false
    t.index ["city_id"], name: "index_ppa_revision_review_new_problem_situations_on_city_id", using: :btree
    t.index ["region_theme_id"], name: "index_ppa_r_r_new_problem_situations_region_axis_themes", using: :btree
  end

  create_table "ppa_revision_review_new_regional_strategies", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "region_theme_id"
    t.index ["region_theme_id"], name: "index_ppa_r_r_new_regional_strategies_region_axis_themes", using: :btree
  end

  create_table "ppa_revision_review_problem_situation_strategies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "plan_id"
    t.integer  "user_id"
    t.index ["plan_id"], name: "index_ppa_r_r_problem_situation_strategies_on_ppa_plan_id", using: :btree
    t.index ["user_id"], name: "index_ppa_r_r_problem_situation_strategies_on_user_id", using: :btree
  end

  create_table "ppa_revision_review_problem_situations", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.boolean  "persist"
    t.integer  "problem_situation_id"
    t.integer  "region_theme_id"
    t.index ["problem_situation_id"], name: "index_ppa_revision_review_problem_situations_problem_situation", using: :btree
    t.index ["region_theme_id"], name: "index_ppa_r_r_problem_situations_region_axis_themes", using: :btree
  end

  create_table "ppa_revision_review_region_themes", force: :cascade do |t|
    t.integer  "theme_id"
    t.integer  "region_id"
    t.integer  "problem_situation_strategy_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["problem_situation_strategy_id"], name: "index_ppa_r_r_axis_theme_regions_on_p_s_s_id", using: :btree
    t.index ["region_id"], name: "index_ppa_revision_review_region_themes_on_region_id", using: :btree
    t.index ["theme_id"], name: "index_ppa_revision_review_region_themes_on_theme_id", using: :btree
  end

  create_table "ppa_revision_review_regional_strategies", force: :cascade do |t|
    t.integer  "strategy_id"
    t.boolean  "persist"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "region_theme_id"
    t.index ["region_theme_id"], name: "index_ppa_r_r_regional_strategies_region_axis_themes", using: :btree
    t.index ["strategy_id"], name: "index_ppa_revision_review_regional_strategies_on_strategy_id", using: :btree
  end

  create_table "ppa_revision_schedules", force: :cascade do |t|
    t.date     "start_in",   null: false
    t.date     "end_in",     null: false
    t.integer  "plan_id",    null: false
    t.integer  "stage",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_ppa_revision_schedules_on_plan_id", using: :btree
  end

  create_table "ppa_situations", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "isn_solucao"
  end

  create_table "ppa_strategies", force: :cascade do |t|
    t.integer  "objective_id",       null: false
    t.string   "code",               null: false
    t.string   "name",               null: false
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "objective_theme_id"
    t.integer  "isn"
    t.datetime "disabled_at"
    t.index ["objective_id"], name: "index_ppa_strategies_on_objective_id", using: :btree
  end

  create_table "ppa_strategies_vote_items", force: :cascade do |t|
    t.integer  "strategy_id"
    t.integer  "strategies_vote_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["strategies_vote_id"], name: "index_ppa_strategies_vote_items_on_strategies_vote_id", using: :btree
    t.index ["strategy_id"], name: "index_ppa_strategies_vote_items_on_strategy_id", using: :btree
  end

  create_table "ppa_strategies_votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "region_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id"], name: "index_ppa_strategies_votes_on_region_id", using: :btree
    t.index ["user_id"], name: "index_ppa_strategies_votes_on_user_id", using: :btree
  end

  create_table "ppa_theme_strategies", force: :cascade do |t|
    t.integer  "theme_id"
    t.integer  "strategy_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["strategy_id"], name: "index_ppa_theme_strategies_on_strategy_id", using: :btree
    t.index ["theme_id"], name: "index_ppa_theme_strategies_on_theme_id", using: :btree
  end

  create_table "ppa_themes", force: :cascade do |t|
    t.integer  "axis_id",     null: false
    t.string   "code",        null: false
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "isn"
    t.datetime "disabled_at"
    t.index ["axis_id"], name: "index_ppa_themes_on_axis_id", using: :btree
    t.index ["isn"], name: "index_ppa_themes_on_isn", using: :btree
  end

  create_table "ppa_votings", force: :cascade do |t|
    t.date     "start_in",   null: false
    t.date     "end_in",     null: false
    t.integer  "plan_id",    null: false
    t.integer  "region_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_ppa_votings_on_plan_id", using: :btree
    t.index ["region_id"], name: "index_ppa_votings_on_region_id", using: :btree
  end

  create_table "ppa_workshops", force: :cascade do |t|
    t.integer  "plan_id",            null: false
    t.string   "name",               null: false
    t.datetime "start_at",           null: false
    t.datetime "end_at",             null: false
    t.integer  "city_id",            null: false
    t.string   "address"
    t.integer  "participants_count"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "link"
    t.index ["city_id"], name: "index_ppa_workshops_on_city_id", using: :btree
    t.index ["plan_id"], name: "index_ppa_workshops_on_plan_id", using: :btree
  end

  create_table "search_content_translations", force: :cascade do |t|
    t.integer  "search_content_id", null: false
    t.string   "locale",            null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "title"
    t.text     "description"
    t.text     "content"
    t.index ["locale"], name: "index_search_content_translations_on_locale", using: :btree
    t.index ["search_content_id"], name: "index_search_content_translations_on_search_content_id", using: :btree
  end

  create_table "search_contents", force: :cascade do |t|
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "organ_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "code"
    t.boolean  "other_organs", default: false
    t.datetime "disabled_at"
    t.integer  "subnet_id"
    t.index ["organ_id"], name: "index_service_types_on_organ_id", using: :btree
  end

  create_table "services_rating_exports", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "ends_at"
    t.string   "filename"
    t.string   "log"
    t.integer  "status"
    t.integer  "worksheet_format"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "services_ratings", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "solvability_reports", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.integer  "status"
    t.text     "filters"
    t.string   "filename"
    t.integer  "processed"
    t.integer  "total"
    t.integer  "total_to_process"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_solvability_reports_on_user_id", using: :btree
  end

  create_table "sou_evaluation_sample_details", force: :cascade do |t|
    t.integer  "sou_evaluation_sample_id"
    t.integer  "ticket_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "rated",                    default: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sou_evaluation_sample_details_on_deleted_at", using: :btree
    t.index ["sou_evaluation_sample_id"], name: "index_sou_evaluation_sample_details_on_sou_evaluation_sample_id", using: :btree
    t.index ["ticket_id"], name: "index_sou_evaluation_sample_details_on_ticket_id", using: :btree
  end

  create_table "sou_evaluation_samples", force: :cascade do |t|
    t.integer  "code"
    t.integer  "status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "created_by_id"
    t.jsonb    "filters"
    t.string   "title"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_sou_evaluation_samples_on_deleted_at", using: :btree
  end

  create_table "states", force: :cascade do |t|
    t.integer "code",    null: false
    t.string  "acronym", null: false
    t.string  "name",    null: false
  end

  create_table "stats_evaluations", force: :cascade do |t|
    t.jsonb    "data"
    t.integer  "evaluation_type"
    t.integer  "month"
    t.integer  "year"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["evaluation_type"], name: "index_stats_evaluations_on_evaluation_type", using: :btree
    t.index ["year", "month"], name: "index_stats_evaluations_on_year_and_month", using: :btree
  end

  create_table "stats_tickets", force: :cascade do |t|
    t.integer  "ticket_type"
    t.integer  "month_start"
    t.integer  "year"
    t.text     "data"
    t.integer  "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "month_end"
    t.integer  "organ_id"
    t.integer  "subnet_id"
    t.index ["organ_id"], name: "index_stats_tickets_on_organ_id", using: :btree
    t.index ["subnet_id"], name: "index_stats_tickets_on_subnet_id", using: :btree
  end

  create_table "sub_departments", force: :cascade do |t|
    t.string   "name"
    t.integer  "department_id"
    t.string   "acronym"
    t.datetime "deleted_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.datetime "disabled_at"
    t.index ["deleted_at"], name: "index_sub_departments_on_deleted_at", using: :btree
    t.index ["department_id"], name: "index_sub_departments_on_department_id", using: :btree
    t.index ["name"], name: "index_sub_departments_on_name", using: :btree
  end

  create_table "subnets", force: :cascade do |t|
    t.string   "name"
    t.integer  "organ_id"
    t.string   "acronym"
    t.datetime "deleted_at"
    t.datetime "disabled_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "ignore_sectoral_validation"
    t.index ["deleted_at"], name: "index_subnets_on_deleted_at", using: :btree
    t.index ["disabled_at"], name: "index_subnets_on_disabled_at", using: :btree
    t.index ["organ_id"], name: "index_subnets_on_organ_id", using: :btree
  end

  create_table "subtopics", force: :cascade do |t|
    t.string   "name"
    t.integer  "topic_id",                     null: false
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "other_organs", default: false
    t.datetime "disabled_at"
    t.index ["deleted_at"], name: "index_subtopics_on_deleted_at", using: :btree
    t.index ["name", "topic_id", "deleted_at"], name: "index_subtopics_on_name_and_topic_id_and_deleted_at", unique: true, using: :btree
    t.index ["topic_id"], name: "index_subtopics_on_topic_id", using: :btree
  end

  create_table "survey_answer_exports", force: :cascade do |t|
    t.string   "name"
    t.datetime "start_at"
    t.datetime "ends_at"
    t.string   "filename"
    t.string   "log"
    t.integer  "status"
    t.integer  "worksheet_format"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_survey_answer_exports_on_user_id", using: :btree
  end

  create_table "themes", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "disabled_at"
    t.index ["deleted_at"], name: "index_themes_on_deleted_at", using: :btree
  end

  create_table "ticket_department_emails", force: :cascade do |t|
    t.integer  "ticket_department_id"
    t.string   "email"
    t.string   "token"
    t.boolean  "active",               default: true
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "answer_id"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_ticket_department_emails_on_deleted_at", using: :btree
    t.index ["ticket_department_id"], name: "index_ticket_department_emails_on_ticket_department_id", using: :btree
    t.index ["token"], name: "index_ticket_department_emails_on_token", using: :btree
  end

  create_table "ticket_department_sub_departments", force: :cascade do |t|
    t.integer  "ticket_department_id"
    t.integer  "sub_department_id"
    t.datetime "deleted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["deleted_at"], name: "index_ticket_department_sub_departments_on_deleted_at", using: :btree
    t.index ["sub_department_id"], name: "index_ticket_department_sub_departments_on_sub_department_id", using: :btree
    t.index ["ticket_department_id"], name: "index_ticket_department_sub_departments_on_ticket_department_id", using: :btree
  end

  create_table "ticket_departments", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "department_id"
    t.text     "description"
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "answer",           default: 0
    t.text     "note"
    t.integer  "deadline"
    t.date     "deadline_ends_at"
    t.string   "considerations"
    t.integer  "user_id"
    t.index ["deleted_at"], name: "index_ticket_departments_on_deleted_at", using: :btree
    t.index ["department_id"], name: "index_ticket_departments_on_department_id", using: :btree
    t.index ["ticket_id"], name: "index_ticket_departments_on_ticket_id", using: :btree
    t.index ["user_id"], name: "index_ticket_departments_on_user_id", using: :btree
  end

  create_table "ticket_likes", force: :cascade do |t|
    t.integer  "ticket_id",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_likes_on_ticket_id", using: :btree
    t.index ["user_id"], name: "index_ticket_likes_on_user_id", using: :btree
  end

  create_table "ticket_logs", force: :cascade do |t|
    t.integer  "ticket_id"
    t.string   "responsible_type"
    t.integer  "responsible_id"
    t.integer  "action"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "description"
    t.text     "data"
    t.index ["action", "created_at"], name: "index_ticket_logs_on_action_created_at", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_ticket_logs_on_resource_type_and_resource_id", using: :btree
    t.index ["responsible_type", "responsible_id"], name: "index_ticket_logs_on_responsible_type_and_responsible_id", using: :btree
    t.index ["ticket_id"], name: "index_ticket_logs_on_ticket_id", using: :btree
  end

  create_table "ticket_protect_attachments", force: :cascade do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "attachment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.index ["attachment_id"], name: "index_ticket_protect_attachments_on_attachment_id", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_ticket_protect_attachments_on_resource_type_and_id", using: :btree
    t.index ["user_id"], name: "index_ticket_protect_attachments_on_user_id", using: :btree
  end

  create_table "ticket_reports", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "filters"
    t.integer  "status"
    t.string   "filename"
    t.integer  "processed"
    t.integer  "total"
    t.integer  "total_to_process"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_ticket_reports_on_user_id", using: :btree
  end

  create_table "ticket_subscriptions", force: :cascade do |t|
    t.integer  "ticket_id",                       null: false
    t.integer  "user_id"
    t.string   "email",                           null: false
    t.string   "token"
    t.boolean  "confirmed_email", default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["email"], name: "index_ticket_subscriptions_on_email", using: :btree
    t.index ["ticket_id"], name: "index_ticket_subscriptions_on_ticket_id", using: :btree
    t.index ["token"], name: "index_ticket_subscriptions_on_token", using: :btree
    t.index ["user_id"], name: "index_ticket_subscriptions_on_user_id", using: :btree
  end

  create_table "tickets", force: :cascade do |t|
    t.text     "description"
    t.integer  "answer_type"
    t.string   "email"
    t.string   "name"
    t.integer  "protocol",                      default: -> { "nextval('protocol_seq'::regclass)" }
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                                         null: false
    t.datetime "updated_at",                                                                         null: false
    t.integer  "organ_id"
    t.string   "encrypted_password",            default: "",                                         null: false
    t.integer  "status",                        default: 0,                                          null: false
    t.integer  "sign_in_count",                 default: 0,                                          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "ticket_type",                   default: 1
    t.integer  "sou_type"
    t.boolean  "anonymous"
    t.boolean  "unknown_organ"
    t.string   "answer_phone"
    t.string   "answer_address_city_name"
    t.string   "answer_address_street"
    t.string   "answer_address_number"
    t.string   "answer_address_zipcode"
    t.string   "answer_address_complement"
    t.string   "answer_address_neighborhood"
    t.integer  "internal_status"
    t.boolean  "classified",                    default: false
    t.integer  "parent_id"
    t.integer  "reopened",                      default: 0,                                          null: false
    t.datetime "confirmed_at"
    t.integer  "deadline"
    t.integer  "document_type"
    t.string   "document"
    t.integer  "person_type",                   default: 0
    t.date     "deadline_ends_at"
    t.integer  "denunciation_organ_id"
    t.text     "denunciation_description"
    t.string   "denunciation_date"
    t.string   "denunciation_place"
    t.integer  "denunciation_assurance"
    t.text     "denunciation_witness"
    t.text     "denunciation_evidence"
    t.datetime "reopened_at"
    t.datetime "responded_at"
    t.integer  "used_input",                    default: 1,                                          null: false
    t.integer  "answer_classification"
    t.integer  "call_center_responsible_id"
    t.string   "answer_cell_phone"
    t.boolean  "priority"
    t.string   "answer_twitter"
    t.string   "answer_facebook"
    t.string   "plain_password"
    t.integer  "city_id"
    t.string   "social_name"
    t.integer  "gender"
    t.datetime "call_center_allocation_at"
    t.boolean  "extended",                      default: false
    t.boolean  "unknown_subnet"
    t.integer  "subnet_id"
    t.string   "used_input_url"
    t.boolean  "public_ticket",                 default: false
    t.boolean  "published",                     default: false
    t.string   "parent_protocol"
    t.integer  "appeals",                       default: 0
    t.datetime "appeals_at"
    t.string   "answer_instagram"
    t.datetime "call_center_feedback_at"
    t.boolean  "denunciation_against_operator"
    t.integer  "call_center_status"
    t.boolean  "parent_unknown_organ"
    t.string   "target_address_zipcode"
    t.integer  "target_city_id"
    t.string   "target_address_street"
    t.string   "target_address_number"
    t.string   "target_address_neighborhood"
    t.string   "target_address_complement"
    t.boolean  "immediate_answer"
    t.boolean  "unknown_classification",        default: false
    t.text     "note"
    t.integer  "isn_manifestacao"
    t.integer  "isn_manifestacao_entidade"
    t.boolean  "rede_ouvir",                    default: false
    t.integer  "citizen_topic_id"
    t.boolean  "extended_second_time",          default: false
    t.boolean  "hide_personal_info"
    t.integer  "denunciation_type"
    t.string   "answer_whatsapp"
    t.boolean  "internal_evaluation",           default: false
    t.boolean  "pseudo_reopen"
    t.boolean  "marked_internal_evaluation"
    t.boolean  "decrement_deadline"
    t.datetime "deadline_updated_at"
    t.index ["anonymous"], name: "index_tickets_on_anonymous", using: :btree
    t.index ["call_center_responsible_id"], name: "index_tickets_on_call_center_responsible_id", using: :btree
    t.index ["citizen_topic_id"], name: "index_tickets_on_citizen_topic_id", using: :btree
    t.index ["city_id"], name: "index_tickets_on_city_id", using: :btree
    t.index ["created_by_id"], name: "index_tickets_on_created_by_id", using: :btree
    t.index ["deleted_at"], name: "index_tickets_on_deleted_at", using: :btree
    t.index ["denunciation_organ_id"], name: "index_tickets_on_denunciation_organ_id", using: :btree
    t.index ["organ_id"], name: "index_tickets_on_organ_id", using: :btree
    t.index ["parent_id"], name: "index_tickets_on_parent_id", using: :btree
    t.index ["parent_protocol"], name: "index_tickets_on_parent_protocol", using: :btree
    t.index ["protocol"], name: "index_tickets_on_protocol", using: :btree
    t.index ["sou_type"], name: "index_tickets_on_sou_type", using: :btree
    t.index ["status"], name: "index_tickets_on_status", using: :btree
    t.index ["subnet_id"], name: "index_tickets_on_subnet_id", using: :btree
    t.index ["ticket_type", "deadline", "internal_status", "extended"], name: "index_ticket_type_deadline_internal_status_extended", using: :btree
    t.index ["ticket_type", "sou_type", "internal_status"], name: "index_tickets_on_ticket_type_and_sou_type_and_internal_status", using: :btree
    t.index ["ticket_type"], name: "index_tickets_on_ticket_type", using: :btree
    t.index ["unknown_organ"], name: "index_tickets_on_unknown_organ", using: :btree
    t.index ["unknown_subnet"], name: "index_tickets_on_unknown_subnet", using: :btree
    t.index ["updated_by_id"], name: "index_tickets_on_updated_by_id", using: :btree
  end

  create_table "tickets_aud", id: :bigserial, force: :cascade do |t|
    t.integer  "id_tickets"
    t.text     "description"
    t.integer  "answer_type"
    t.string   "email"
    t.string   "name"
    t.integer  "protocol"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organ_id"
    t.string   "encrypted_password"
    t.integer  "status"
    t.integer  "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "ticket_type"
    t.integer  "sou_type"
    t.boolean  "anonymous"
    t.boolean  "unknown_organ"
    t.string   "answer_phone"
    t.string   "answer_address_city_name"
    t.string   "answer_address_street"
    t.string   "answer_address_number"
    t.string   "answer_address_zipcode"
    t.string   "answer_address_complement"
    t.string   "answer_address_neighborhood"
    t.integer  "internal_status"
    t.boolean  "classified"
    t.integer  "parent_id"
    t.integer  "reopened"
    t.datetime "confirmed_at"
    t.integer  "deadline"
    t.integer  "document_type"
    t.string   "document"
    t.integer  "person_type"
    t.date     "deadline_ends_at"
    t.integer  "denunciation_organ_id"
    t.text     "denunciation_description"
    t.string   "denunciation_date"
    t.string   "denunciation_place"
    t.integer  "denunciation_assurance"
    t.text     "denunciation_witness"
    t.text     "denunciation_evidence"
    t.datetime "reopened_at"
    t.datetime "responded_at"
    t.integer  "used_input"
    t.integer  "answer_classification"
    t.integer  "call_center_responsible_id"
    t.string   "answer_cell_phone"
    t.boolean  "priority"
    t.string   "answer_twitter"
    t.string   "answer_facebook"
    t.string   "plain_password"
    t.integer  "city_id"
    t.string   "social_name"
    t.integer  "gender"
    t.datetime "call_center_allocation_at"
    t.boolean  "extended"
    t.boolean  "unknown_subnet"
    t.integer  "subnet_id"
    t.string   "used_input_url"
    t.boolean  "public_ticket"
    t.boolean  "published"
    t.string   "parent_protocol"
    t.integer  "appeals"
    t.datetime "appeals_at"
    t.string   "answer_instagram"
    t.datetime "call_center_feedback_at"
    t.boolean  "denunciation_against_operator"
    t.integer  "call_center_status"
    t.boolean  "parent_unknown_organ"
    t.string   "target_address_zipcode"
    t.integer  "target_city_id"
    t.string   "target_address_street"
    t.string   "target_address_number"
    t.string   "target_address_neighborhood"
    t.string   "target_address_complement"
    t.boolean  "immediate_answer"
    t.boolean  "unknown_classification"
    t.text     "note"
    t.integer  "isn_manifestacao"
    t.integer  "isn_manifestacao_entidade"
    t.boolean  "rede_ouvir"
    t.datetime "data_operacao_aud"
    t.string   "operacao_aud",                  limit: 25
    t.string   "usuario_aud",                   limit: 255
    t.index ["id_tickets"], name: "index_tickets_aud_on_id_tickets", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "organ_id"
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "other_organs", default: false
    t.datetime "disabled_at"
    t.index ["deleted_at"], name: "index_topics_on_deleted_at", using: :btree
    t.index ["name"], name: "index_topics_on_name", using: :btree
    t.index ["organ_id"], name: "index_topics_on_organ_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "deleted_at"
    t.integer  "user_type"
    t.string   "email",                  default: "",         null: false
    t.string   "encrypted_password",     default: "",         null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,          null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "document_type"
    t.string   "document"
    t.integer  "operator_type"
    t.integer  "organ_id"
    t.integer  "department_id"
    t.integer  "person_type",            default: 0
    t.string   "provider"
    t.string   "uid"
    t.string   "social_name"
    t.integer  "gender"
    t.boolean  "denunciation_tracking",  default: false
    t.integer  "education_level"
    t.date     "birthday"
    t.boolean  "server",                 default: false
    t.string   "facebook_profile_link"
    t.integer  "city_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "notification_roles",     default: "--- {}\n"
    t.boolean  "positioning",            default: false
    t.datetime "disabled_at"
    t.integer  "subnet_id"
    t.boolean  "internal_subnet"
    t.integer  "sub_department_id"
    t.boolean  "acts_as_sic",            default: false
    t.boolean  "rede_ouvir",             default: false
    t.boolean  "sectoral_denunciation",  default: true
    t.datetime "password_changed_at"
    t.index ["city_id"], name: "index_users_on_city_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
    t.index ["department_id"], name: "index_users_on_department_id", using: :btree
    t.index ["document_type"], name: "index_users_on_document_type", using: :btree
    t.index ["email", "deleted_at"], name: "index_users_on_email_and_deleted_at", unique: true, using: :btree
    t.index ["operator_type"], name: "index_users_on_operator_type", using: :btree
    t.index ["organ_id"], name: "index_users_on_organ_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["sub_department_id"], name: "index_users_on_sub_department_id", using: :btree
    t.index ["subnet_id"], name: "index_users_on_subnet_id", using: :btree
    t.index ["user_type"], name: "index_users_on_user_type", using: :btree
  end

  add_foreign_key "attendance_evaluations", "tickets"
  add_foreign_key "attendance_evaluations", "users", column: "created_by_id"
  add_foreign_key "attendance_evaluations", "users", column: "updated_by_id"
  add_foreign_key "attendances", "tickets"
  add_foreign_key "authentication_tokens", "users"
  add_foreign_key "budget_programs", "organs"
  add_foreign_key "budget_programs", "subnets"
  add_foreign_key "budget_programs", "themes"
  add_foreign_key "cities", "states"
  add_foreign_key "citizen_comments", "tickets"
  add_foreign_key "citizen_comments", "users"
  add_foreign_key "classifications", "budget_programs"
  add_foreign_key "classifications", "departments"
  add_foreign_key "classifications", "service_types"
  add_foreign_key "classifications", "sub_departments"
  add_foreign_key "classifications", "subtopics"
  add_foreign_key "classifications", "tickets"
  add_foreign_key "classifications", "topics"
  add_foreign_key "departments", "organs"
  add_foreign_key "evaluation_exports", "users"
  add_foreign_key "evaluations", "answers"
  add_foreign_key "extensions", "ticket_departments"
  add_foreign_key "gross_exports", "users"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "mobile_apps_tags", "mobile_apps"
  add_foreign_key "mobile_apps_tags", "mobile_tags"
  add_foreign_key "occurrences", "attendances"
  add_foreign_key "organ_associations", "organs"
  add_foreign_key "page_charts", "pages"
  add_foreign_key "page_series_data", "page_charts"
  add_foreign_key "page_series_items", "page_series_data"
  add_foreign_key "pages", "pages", column: "parent_id"
  add_foreign_key "ppa_annual_regional_initiative_budgets", "ppa_annual_regional_initiatives", column: "regional_initiative_id"
  add_foreign_key "ppa_annual_regional_initiatives", "ppa_initiatives", column: "initiative_id"
  add_foreign_key "ppa_annual_regional_initiatives", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_annual_regional_product_goals", "ppa_annual_regional_products", column: "regional_product_id"
  add_foreign_key "ppa_annual_regional_products", "ppa_products", column: "product_id"
  add_foreign_key "ppa_annual_regional_products", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_annual_regional_strategies", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_annual_regional_strategies", "ppa_strategies", column: "strategy_id"
  add_foreign_key "ppa_axes", "ppa_plans", column: "plan_id"
  add_foreign_key "ppa_biennial_regional_initiative_budgets", "ppa_biennial_regional_initiatives", column: "regional_initiative_id"
  add_foreign_key "ppa_biennial_regional_initiatives", "ppa_initiatives", column: "initiative_id"
  add_foreign_key "ppa_biennial_regional_initiatives", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_biennial_regional_product_goals", "ppa_biennial_regional_products", column: "regional_product_id"
  add_foreign_key "ppa_biennial_regional_products", "ppa_products", column: "product_id"
  add_foreign_key "ppa_biennial_regional_products", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_biennial_regional_strategies", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_biennial_regional_strategies", "ppa_strategies", column: "strategy_id"
  add_foreign_key "ppa_objective_themes", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_objectives", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_problem_situations", "ppa_axes", column: "axis_id"
  add_foreign_key "ppa_problem_situations", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_problem_situations", "ppa_situations", column: "situation_id"
  add_foreign_key "ppa_problem_situations", "ppa_themes", column: "theme_id"
  add_foreign_key "ppa_products", "ppa_initiatives", column: "initiative_id"
  add_foreign_key "ppa_proposal_themes", "ppa_plans", column: "plan_id"
  add_foreign_key "ppa_proposal_themes", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_proposals", "cities"
  add_foreign_key "ppa_proposals", "ppa_objectives", column: "objective_id"
  add_foreign_key "ppa_proposals", "ppa_plans", column: "plan_id"
  add_foreign_key "ppa_proposals", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_regional_initiative_budgets", "ppa_regional_initiatives", column: "regional_initiative_id"
  add_foreign_key "ppa_regional_initiatives", "ppa_initiatives", column: "initiative_id"
  add_foreign_key "ppa_regional_initiatives", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_regional_product_goals", "ppa_regional_products", column: "regional_product_id"
  add_foreign_key "ppa_regional_products", "ppa_products", column: "product_id"
  add_foreign_key "ppa_regional_products", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_revision_evaluations", "ppa_plans", column: "plan_id"
  add_foreign_key "ppa_revision_evaluations", "users"
  add_foreign_key "ppa_revision_participant_profiles", "users"
  add_foreign_key "ppa_revision_prioritization_region_themes", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_revision_prioritization_region_themes", "ppa_revision_prioritizations", column: "prioritization_id"
  add_foreign_key "ppa_revision_prioritization_region_themes", "ppa_themes", column: "theme_id"
  add_foreign_key "ppa_revision_prioritization_regional_strategies", "ppa_revision_prioritization_region_themes", column: "region_theme_id"
  add_foreign_key "ppa_revision_prioritization_regional_strategies", "ppa_strategies", column: "strategy_id"
  add_foreign_key "ppa_revision_prioritizations", "ppa_plans", column: "plan_id"
  add_foreign_key "ppa_revision_prioritizations", "users"
  add_foreign_key "ppa_revision_review_new_problem_situations", "cities"
  add_foreign_key "ppa_revision_review_new_problem_situations", "ppa_revision_review_region_themes", column: "region_theme_id"
  add_foreign_key "ppa_revision_review_new_regional_strategies", "ppa_revision_review_region_themes", column: "region_theme_id"
  add_foreign_key "ppa_revision_review_problem_situation_strategies", "ppa_plans", column: "plan_id"
  add_foreign_key "ppa_revision_review_problem_situation_strategies", "users"
  add_foreign_key "ppa_revision_review_problem_situations", "ppa_problem_situations", column: "problem_situation_id"
  add_foreign_key "ppa_revision_review_problem_situations", "ppa_revision_review_region_themes", column: "region_theme_id"
  add_foreign_key "ppa_revision_review_region_themes", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_revision_review_region_themes", "ppa_revision_review_problem_situation_strategies", column: "problem_situation_strategy_id"
  add_foreign_key "ppa_revision_review_region_themes", "ppa_themes", column: "theme_id"
  add_foreign_key "ppa_revision_review_regional_strategies", "ppa_revision_review_region_themes", column: "region_theme_id"
  add_foreign_key "ppa_revision_review_regional_strategies", "ppa_strategies", column: "strategy_id"
  add_foreign_key "ppa_revision_schedules", "ppa_plans", column: "plan_id"
  add_foreign_key "ppa_strategies", "ppa_objective_themes", column: "objective_theme_id"
  add_foreign_key "ppa_strategies", "ppa_objectives", column: "objective_id"
  add_foreign_key "ppa_strategies_vote_items", "ppa_strategies", column: "strategy_id"
  add_foreign_key "ppa_strategies_vote_items", "ppa_strategies_votes", column: "strategies_vote_id"
  add_foreign_key "ppa_strategies_votes", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_strategies_votes", "users"
  add_foreign_key "ppa_theme_strategies", "ppa_strategies", column: "strategy_id"
  add_foreign_key "ppa_theme_strategies", "ppa_themes", column: "theme_id"
  add_foreign_key "ppa_themes", "ppa_axes", column: "axis_id"
  add_foreign_key "ppa_votings", "ppa_plans", column: "plan_id"
  add_foreign_key "ppa_votings", "ppa_regions", column: "region_id"
  add_foreign_key "ppa_workshops", "ppa_plans", column: "plan_id"
  add_foreign_key "service_types", "organs"
  add_foreign_key "solvability_reports", "users"
  add_foreign_key "sou_evaluation_sample_details", "sou_evaluation_samples"
  add_foreign_key "sou_evaluation_sample_details", "tickets"
  add_foreign_key "stats_tickets", "organs"
  add_foreign_key "stats_tickets", "subnets"
  add_foreign_key "sub_departments", "departments"
  add_foreign_key "subnets", "organs"
  add_foreign_key "subtopics", "topics"
  add_foreign_key "survey_answer_exports", "users"
  add_foreign_key "ticket_department_sub_departments", "sub_departments"
  add_foreign_key "ticket_department_sub_departments", "ticket_departments"
  add_foreign_key "ticket_departments", "departments"
  add_foreign_key "ticket_departments", "tickets"
  add_foreign_key "ticket_departments", "users"
  add_foreign_key "ticket_likes", "tickets"
  add_foreign_key "ticket_likes", "users"
  add_foreign_key "ticket_logs", "tickets"
  add_foreign_key "ticket_protect_attachments", "attachments"
  add_foreign_key "ticket_protect_attachments", "users"
  add_foreign_key "ticket_reports", "users"
  add_foreign_key "ticket_subscriptions", "tickets"
  add_foreign_key "ticket_subscriptions", "users"
  add_foreign_key "tickets", "cities"
  add_foreign_key "tickets", "organs"
  add_foreign_key "tickets", "organs", column: "denunciation_organ_id"
  add_foreign_key "tickets", "tickets", column: "parent_id"
  add_foreign_key "tickets", "users", column: "created_by_id"
  add_foreign_key "tickets", "users", column: "updated_by_id"
  add_foreign_key "topics", "organs"
  add_foreign_key "users", "cities"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "organs"
  add_foreign_key "users", "sub_departments"
end
