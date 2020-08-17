# frozen_string_literal: true

ENV_FILE_NAME = '.env.production'

require './config/dotenv.rb'
require './config/redis.rb'
require './config/sequel.rb'
require './config/i18n.rb'
require './config/telegram_bot.rb'
require './config/telegram-app_manager.rb'
require './config/sidekiq.rb'
