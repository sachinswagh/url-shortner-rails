# frozen_string_literal: true

class AuthService
  class << self
    def create_session(user_id)
      user_session = UserSession.new
      user_session.user_id = user_id
      user_session.identifier = SecureRandom.uuid
      user_session.is_alive = 1
      user_session.latest_transaction = Time.current
      user_session.save
      user_session.reload
      user_session
    end

    def get_session(identifier)
      UserSession.where("identifier='#{identifier}'").first
    end

    def update_session(session)
      session.is_alive = 1
      session.latest_transaction = Time.current
      session.save
      session.reload
    end
  end
end
