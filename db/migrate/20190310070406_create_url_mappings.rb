# frozen_string_literal: true

class CreateUrlMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :url_mappings do |t|
      t.string :short_url, index: true
      t.text :long_url, index: true
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
