# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, index: true
      t.string :crypted_password
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
