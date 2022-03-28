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

ActiveRecord::Schema.define(version: 2022_03_28_115139) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'bank_accounts', force: :cascade do |t|
    t.bigint 'user_id'
    t.float 'amount'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'trades_done_count', default: 0, null: false
    t.index ['user_id'], name: 'index_bank_accounts_on_user_id'
  end

  create_table 'trade_types', primary_key: 'name', id: :string, force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_trade_types_on_name'
  end

  create_table 'trades', force: :cascade do |t|
    t.string 'trade_type', null: false
    t.integer 'account_id', null: false
    t.string 'symbol', null: false
    t.integer 'shares', null: false
    t.float 'price', null: false
    t.string 'state', null: false
    t.integer 'timestamp', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'job_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'surname', null: false
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.boolean 'active', default: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  add_foreign_key 'bank_accounts', 'users'
  add_foreign_key 'trades', 'bank_accounts', column: 'account_id', on_delete: :nullify
  add_foreign_key 'trades', 'trade_types', column: 'trade_type', primary_key: 'name', on_delete: :nullify
end
