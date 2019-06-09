# frozen_string_literal: true

# == Schema Information
#
# Table name: auth_details
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  auth_key   :text
#  expired_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe AuthDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
