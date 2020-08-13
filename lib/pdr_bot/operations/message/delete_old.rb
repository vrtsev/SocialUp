# frozen_string_literal: true

module PdrBot
  module Op
    module Message
      class DeleteOld < Telegram::AppManager::BaseOperation
        OLD_MESSAGES_AGE = 90

        step :delete_messages

        def delete_messages(ctx, **)
          PdrBot::MessageRepository.new.delete_old(OLD_MESSAGES_AGE)
        end
      end
    end
  end
end
