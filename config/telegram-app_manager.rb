Telegram::AppManager.configure do |config|
  config.controller_logging = true
  config.show_app_start_message = true
  config.telegram_app_owner_id = ENV['TELEGRAM_APP_OWNER_ID']
end
