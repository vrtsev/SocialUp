# frozen_string_literal: true

module AdminBot
  module Responders
    module AdminBot
      class StartMessage < Telegram::AppManager::BaseResponder
        def call
          send_message(
            text,
            bot: Telegram.bots[:admin_bot],
            chat_id: params[:current_chat_id]
          )
        end

        private

        def text
          ::AdminBot.localizer.pick('start_message', role: params[:role])
        end
      end
    end
  end
end