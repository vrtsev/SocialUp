# frozen_string_literal: true

module PdrBot
  class MessageRepository < Telegram::AppManager::BaseRepository
    def delete_old(age)
      model
        .where { created_at < (Date.today - age).to_time }
        .delete
    end

    private

    def model
      PdrBot::Message
    end
  end
end
