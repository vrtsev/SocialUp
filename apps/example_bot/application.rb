# frozen_string_literal: true

require_all 'apps/example_bot/concerns'
require_all 'apps/example_bot/responders'
require_relative 'exception_handler.rb'
require_relative 'controller.rb'

module ExampleBot
  class Application < Telegram::AppManager::Application
    private

    def controller
      ExampleBot::Controller
    end
  end
end
