# frozen_string_literal: true

class CreateAuthDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :auth_details do |t|
      t.integer :user_id
      t.text :auth_key
      t.datetime :expired_at

      t.timestamps
    end
  end
end
