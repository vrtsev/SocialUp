# frozen_string_literal: true

module JeniaBot
  class User < Sequel::Model(:jenia_bot_users)
    def full_name
      if first_name && last_name
        "#{first_name} #{last_name}"
      elsif first_name || last_name
        first_name || last_name
      else
        username
      end
    end
  end
end
