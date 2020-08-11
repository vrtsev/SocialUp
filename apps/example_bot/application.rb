require_all 'apps/example_bot/concerns'
require_all 'apps/example_bot/responders'
require_relative 'controller.rb'

module ExampleBot
  class Application < Telegram::AppManager::Application
    FIRST_AUTO_ANSWER_ID = 1

    def configure
      super

      # Autocreate or find first autoanswer
      ExampleBot::AutoAnswerRepository.new.find_or_create(FIRST_AUTO_ANSWER_ID, {
        approved: true,
        author_id: 999999, # some rand id. it does not matter by business logic
        chat_id: 999999, # some rand id. it does not matter by business logic
        trigger: 'Hello bot',
        answer: 'Hellooo. How are you?'
      })
    end

    def run
      super
    rescue HTTPClient::ReceiveTimeoutError => exception
      puts "Poller timeout error. Reconnecting"
      run
    end

    private

    def controller
      ExampleBot::Controller
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
      Telegram::AppManager::Message
        .new(Telegram.bots[:admin_bot], exception.full_message.truncate(4000))
        .send_to_app_owner
      raise exception
    end

  end
end
