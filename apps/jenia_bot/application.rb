require_all 'apps/jenia_bot/concerns'
require_all 'apps/jenia_bot/views'
require_relative 'controller.rb'

module JeniaBot
  class Application < Telegram::BotManager::Application

    def configure
      # Configure your app here
      super
    end

    private

    def controller
      JeniaBot::Controller
    end

    def configuration_message
      # Change config message here
      super
    end

    def startup_message
      # Change startup message here
      super
    end

    def handle_exception(exception)
      puts "[#{@configuration.app_name}] Application raised exception...".bold.red
      Telegram::BotManager::Message
        .new(Telegram.bots[:admin_bot], exception.full_message.truncate(4000))
        .send_to_app_owner
    end

  end
end
