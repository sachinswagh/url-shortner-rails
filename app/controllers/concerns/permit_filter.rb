# frozen_string_literal: true

# PermitFilter
module PermitFilter
  extend ActiveSupport::Concern

  def user_params
    params.fetch(:user, {}).permit!
  end
end
