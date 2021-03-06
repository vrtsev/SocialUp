# frozen_string_literal: true

require_all 'apps/admin_bot/concerns'
require_all 'apps/admin_bot/actions'
require_all 'apps/admin_bot/responders'
require_relative 'exception_handler.rb'
require_relative 'controller.rb'

module AdminBot
  class Application < Telegram::AppManager::Application
    private

    def controller
      AdminBot::Controller
    end
  end
end
