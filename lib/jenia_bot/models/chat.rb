# frozen_string_literal: true

module JeniaBot
  class Chat < Sequel::Model(:jenia_bot_chats)
    class Types
      include Ruby::Enum

      define 'private', 0
      define 'group', 1
      define 'supergroup', 2
      define 'channel', 3
    end

    def name
      title || "#{username} #{first_name} #{last_name}"
    end
  end
end
