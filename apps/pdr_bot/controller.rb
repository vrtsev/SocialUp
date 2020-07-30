# frozen_string_literal: true

module PdrBot
  class Controller < Telegram::AppManager::BaseController
    include ControllerHelpers

    before_action :sync_chat
    before_action :sync_user
    before_action :authenticate_chat
    before_action :sync_message
    before_action :bot_enabled?

    def message(message)
      return unless message['text'].present?

      result = PdrBot::Op::AutoAnswer::Random.call(
        chat: @current_chat, message: @message
      )
      return if operation_error_present?(result)

      if result[:answer].present?
        sleep(rand(2..4))
        reply_with(:message, text: result[:answer])
      end
    end

    def start!
      message = PdrBot::Views::StartMessage.new
      respond_with(:message, text: message.text)
    end

    def pdr!
      result = ::PdrBot::Op::Game::Run.call(user_id: @current_user.id, chat_id: @current_chat.id)
      return if operation_error_present?(result)

      message = PdrBot::Views::Game.new(winner: result[:winner], loser: result[:loser])
      respond_with(:message, text: message.game_start_message); sleep(rand(0..3))
      respond_with(:message, text: message.searching_users)

      results!
    end

    def results!
      result = ::PdrBot::Op::GameRound::LatestResults.call(chat_id: @current_chat.id)
      return if operation_error_present?(result)

      message = PdrBot::Views::Results.new(winner: result[:winner], loser: result[:loser])
      respond_with(:message, text: message.text)
    end

    def stats!
      result = ::PdrBot::Op::Stat::ByChat.call(chat_id: @current_chat.id)
      return if operation_error_present?(result)

      message = PdrBot::Views::Stat.new(
        winner_stat: result[:winner_stat],
        loser_stat: result[:loser_stat],
        chat_stats: result[:chat_stats]
      )
      respond_with(:message, text: message.text)
    end

    private

    def sync_chat
      result = ::PdrBot::Op::Chat::Sync.call(params: Hashie.symbolize_keys(chat))
      PdrBot.logger.debug "* Synced chat ##{result[:chat].id} (#{result[:chat].name})"

      operation_error_present?(result)
      @current_chat = result[:chat]
    end

    def sync_user
      result = ::PdrBot::Op::User::Sync.call(chat_id: @current_chat.id, params: Hashie.symbolize_keys(from))
      PdrBot.logger.debug "* Synced user ##{result[:user].id} (#{result[:user].full_name})"

      operation_error_present?(result)
      @current_user = result[:user]
    end

    def authenticate_chat
      result = ::PdrBot::Op::Chat::Authenticate.call(chat_id: @current_chat.id)

      if result[:approved]
        ::PdrBot.logger.info "* Chat id #{@current_chat.id} is authenticated".bold.green
      else
        ::PdrBot.logger.info "* Chat #{@current_chat.id} failed authentication".bold.red
      end

      throw :abort unless result[:approved]
    end

    def sync_message
      result = PdrBot::Op::Message::Sync.call(
        params: {
          chat_id: @current_chat.id,
          user_id: @current_user.id,
          message_id: payload['message_id'],
          text: payload['text'],
          date: payload['date']
        }
      )

      PdrBot.logger.debug "* Synced message ##{result[:message].id} (#{result[:message].text})"

      operation_error_present?(result)
      @message = result[:message]
    end

    def bot_enabled?
      result = ::PdrBot::Op::Bot::State.call

      if result[:enabled]
        PdrBot.logger.info "* Bot '#{PdrBot.app_name}' enabled".bold.green
      else
        PdrBot.logger.info "* Bot '#{PdrBot.app_name}' disabled.. Skip processing".bold.red
      end

      operation_error_present?(result)
      @bot_enabled = result[:enabled]
      throw :abort unless @bot_enabled
    end
  end
end
