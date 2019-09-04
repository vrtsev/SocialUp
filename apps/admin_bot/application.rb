require_all 'apps/admin_bot/concerns'
require_all 'apps/admin_bot/actions'
require_all 'apps/admin_bot/views'
require_relative 'controller.rb'

module AdminBot
  class Application < Telegram::BotManager::Application

    def configure
      super

      AdminBot::UserRepository.new.find_or_create(ENV['TELEGRAM_APP_OWNER_ID'], {
        id: ENV['TELEGRAM_APP_OWNER_ID'],
        username: ENV['TELEGRAM_APP_OWNER_USERNAME'],
        role: AdminBot::User::Roles.administrator
      })
    end

    private

    def controller
      AdminBot::Controller
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
      raise exception
    end

  end
end
