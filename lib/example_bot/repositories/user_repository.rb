# frozen_string_literal: true

module ExampleBot
  class UserRepository < Telegram::AppManager::BaseRepository
    private

    def model
      ExampleBot::User
    end
  end
end
