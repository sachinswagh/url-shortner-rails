# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_190_314_162_906) do
  create_table 'auth_details', force: :cascade do |t|
    t.integer 'user_id'
    t.text 'auth_key'
    t.datetime 'expired_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'books', force: :cascade do |t|
    t.string 'name'
    t.string 'author'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'url_mappings', force: :cascade do |t|
    t.string 'short_url'
    t.text 'long_url'
    t.boolean 'active', default: true
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['long_url'], name: 'index_url_mappings_on_long_url'
    t.index ['short_url'], name: 'index_url_mappings_on_short_url'
  end

  create_table 'user_sessions', force: :cascade do |t|
    t.string 'identifier'
    t.integer 'user_id'
    t.integer 'role'
    t.datetime 'latest_transaction'
    t.boolean 'is_alive'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['identifier'], name: 'index_user_sessions_on_identifier'
    t.index ['user_id'], name: 'index_user_sessions_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.string 'crypted_password'
    t.string 'first_name'
    t.string 'last_name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email'
  end
end
