# frozen_string_literal: true

module JeniaBot
  module Op
    module Bot
      class State < Telegram::AppManager::BaseOperation
        step :get_value
        fail :set_value, Output(:success) => Track(:success)
        pass :parse_value

        def get_value(ctx, **)
          ctx[:value] = REDIS.get(redis_bot_state_key)
        end

        def set_value(ctx, **)
          REDIS.set(redis_bot_state_key, JSON.parse(ENV['JENIA_BOT_DEFAULT_STATE'])) # HACK: to convert 'true' to bool
          ctx[:value] = REDIS.get(redis_bot_state_key)
        end

        def parse_value(ctx, **)
          ctx[:enabled] = JSON.parse(ctx[:value])
        end

        private

        def redis_bot_state_key
          "#{::Telegram.bots[:jenia_bot].username}:state"
        end
      end
    end
  end
end
