# frozen_string_literal: true

module PdrBot
  module Op
    module Chat
      class Sync < Telegram::AppManager::BaseOperation
        class Contract < Dry::Validation::Contract
          params do
            required(:id).filled(:integer)
            required(:type).filled(:string)

            optional(:title).filled(:string)
            optional(:username).filled(:string)
            optional(:first_name).filled(:string)
            optional(:last_name).filled(:string)
            optional(:description).filled(:string)
            optional(:invite_link).filled(:string)
          end
        end

        DEFAULT_CHAD_APPROVED_STATE = true

        step Macro::Validate(:params, with: Contract)
        pass :prepare_params
        step :find_or_create_chat

        def prepare_params(_ctx, params:, **)
          params[:type] = PdrBot::Chat::Types.value(params[:type])
        end

        def find_or_create_chat(ctx, params:, **)
          ctx[:chat] = PdrBot::ChatRepository.new.find(params[:id])

          unless ctx[:chat].present?
            ctx[:chat] = create_new_chat(ctx[:params])
            report_new_chat(ctx[:chat])
          end

          ctx[:chat]
        end

        private

        def create_new_chat(params)
          PdrBot::ChatRepository.new.create(params.merge!(approved: DEFAULT_CHAD_APPROVED_STATE))
        end

        def report_new_chat(chat)
          Telegram::BotManager::Message
            .new(Telegram.bots[:admin_bot], PdrBot.localizer.pick('new_chat_registered', chat_info: chat.to_hash))
            .send_to_app_owner
        end
      end
    end
  end
end
