# frozen_string_literal: true

module PdrBot
  class GameStatRepository < Telegram::AppManager::BaseRepository
    def find_by_chat_and_user(chat_id, user_id)
      model
        .select_all(:pdr_bot_game_stats)
        .select_append(:username, :first_name, :last_name, :username)
        .left_join(:pdr_bot_users, id: :user_id)
        .where(chat_id: chat_id, user_id: user_id)
        .first
    end

    def find_all_by_chat_id(chat_id)
      model
        .select_all(:pdr_bot_game_stats)
        .select_append(:username, :first_name, :last_name, :username)
        .left_join(:pdr_bot_users, id: :user_id)
        .where(chat_id: chat_id)
        .to_a
    end

    def find_leader_by_chat_id(chat_id:, counter:, exclude_user_id: nil)
      model
        .select_all(:pdr_bot_game_stats)
        .select_append(:username, :first_name, :last_name, :username)
        .left_join(:pdr_bot_users, id: :user_id)
        .where(chat_id: chat_id)
        .exclude(user_id: exclude_user_id)
        .order(counter)
        .last
    end

    def increment(counter, chat_id:, user_id:)
      model
        .dataset
        .returning(counter)
        .where(chat_id: chat_id, user_id: user_id)
        .update(counter => Sequel.expr(1) + counter)
    end

    def decrement(counter, chat_id:, user_id:)
      model
        .dataset
        .returning(counter)
        .where(chat_id: chat_id, user_id: user_id)
        .update(counter => Sequel.expr(1) - counter)
    end

    private

    def model
      PdrBot::GameStat
    end
  end
end
