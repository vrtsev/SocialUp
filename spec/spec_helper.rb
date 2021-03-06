# frozen_string_literal: false

require './config/boot'
require 'sidekiq/testing'
require 'telegram/bot/rspec/integration/poller'

Fabrication.configure do |config|
  config.fabricator_path = 'spec/support/fabricators'
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:sequel].db = ::DB
    DatabaseCleaner.strategy = :truncation # or :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:all) do
    Telegram::AppManager.configure do |app_manager_config|
      app_manager_config.controller_logging = false
    end

    # Enable / disable verbose loggers in specs
    log_level = Logger::ERROR
    PdrBot.logger.level = log_level
    JeniaBot.logger.level = log_level
    AdminBot.logger.level = log_level
    ExampleBot.logger.level = log_level
  end

  config.before(:each) do
    REDIS.set("#{::Telegram.bots[:jenia_bot].username}:state", true)
    REDIS.set("#{::Telegram.bots[:pdr_bot].username}:state", true)
    REDIS.set("#{::Telegram.bots[:example_bot].username}:state", true)
    DatabaseCleaner.start
  end

  config.after(:each) do
    Sidekiq::Worker.clear_all
    DatabaseCleaner.start
  end
end
