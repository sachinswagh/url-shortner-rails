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

require 'rails_helper'

RSpec.describe UrlMapping, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
