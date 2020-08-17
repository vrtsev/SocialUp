# frozen_string_literal: true

module ExampleBot
  module Responders
    class ExceptionReport < Telegram::AppManager::BaseResponder
      def call
        message(
          text,
          bot: Telegram.bots[:admin_bot],
          chat_id: ENV['TELEGRAM_APP_OWNER_ID']
        ).send
      end

      private

      def text
        <<~MSG
          EXCEPTION from #{::ExampleBot.app_name}

          #{params[:class]}: #{params[:message]}
          #{params[:backtrace].first}
        MSG
      end
    end
  end
end
