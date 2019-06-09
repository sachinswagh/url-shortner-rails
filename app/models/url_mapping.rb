# frozen_string_literal: true

# == Schema Information
#
# Table name: url_mappings
#
#  id         :integer          not null, primary key
#  short_url  :string
#  long_url   :text
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# UrlMapping model
class UrlMapping < ApplicationRecord
  # Validations
  validates_uniqueness_of :short_url, :long_url
end
