# frozen_string_literal: true

class CreateUserSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_sessions do |t|
      t.string :identifier, index: true
      t.integer :user_id, index: true
      t.integer :role
      t.datetime :latest_transaction
      t.boolean :is_alive

      t.timestamps
    end
  end
end
