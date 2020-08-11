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
          I18n.t('.admin_bot.start_message', role: params[:role]).sample
        end
      end
    end
  end
end
