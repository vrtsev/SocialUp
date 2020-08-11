module JeniaBot
  module ControllerHelpers

    def operation_error_present?(result)
      return false if result.success?

      if result[:error].present?
        report_to_chat(result[:error])
        true
      else
        raise "Operation failed: #{result.to_hash}"
      end
    end

    def rescue_with_handler(exception)
      message = <<~MSG
        #{exception.class}: #{exception.message}
        #{exception.backtrace.first}
      MSG

      puts "[#{JeniaBot.app_name}] Application raised exception".bold.red
      puts exception.full_message

      report_app_owner(message)
      report_to_chat(JeniaBot.localizer.pick('errors'))
    end

    def report_app_owner(message)
      Telegram::AppManager::Message
        .new(Telegram.bots[:admin_bot], message)
        .send_to_app_owner
    end

    def report_to_chat(message)
      return unless @bot_enabled
      respond_with(:message, text: message)
    end

    def logger
      JeniaBot.logger
    end

  end
end