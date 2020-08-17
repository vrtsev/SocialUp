# frozen_string_literal: true

module PdrBot
  module Op
    module Chat
      class Sync < Telegram::AppManager::BaseOperation
        class Contract < Dry::Validation::Contract
          params do
            # Chat params
            required(:id).filled(:integer)
            optional(:type).filled(included_in?: PdrBot::Chat::Types.values)
            optional(:title).filled(:string)
            optional(:username).filled(:string)
            optional(:first_name).filled(:string)
            optional(:last_name).filled(:string)
            optional(:description).filled(:string)
            optional(:invite_link).filled(:string)
          end
        end

        DEFAULT_CHAD_APPROVED_STATE = true

        pass :prepare_params
        step :validate
        step :find_or_create_chat

        def prepare_params(_ctx, params:, **)
          params[:type] = PdrBot::Chat::Types.value(params[:type])
        end

        def validate(ctx, params:, **)
          ctx[:validation_result] = Contract.new.call(params)
          ctx[:params] = ctx[:validation_result].to_h

          handle_validation_errors(ctx)
        end

        def find_or_create_chat(ctx, params:, **)
          ctx[:chat] = PdrBot::ChatRepository.new.find(params[:id])

          unless ctx[:chat].present?
            ctx[:chat] = create_new_chat(chat_params(params))
            report_new_chat(ctx[:chat])
          end

          ctx[:chat]
        end

        private

        def chat_params(params)
          {
            id: params[:id],
            approved: DEFAULT_CHAD_APPROVED_STATE,
            type: params[:type],
            title: params[:title],
            username: params[:username],
            first_name: params[:first_name],
            last_name: params[:last_name],
            description: params[:description],
            invite_link: params[:invite_link]
          }
        end

        def create_new_chat(params)
          PdrBot::ChatRepository.new.create(params)
        end

        def report_new_chat(chat)
          Telegram::AppManager::Message.new(
            I18n.t('.pdr_bot.new_chat_registered', chat_info: chat.to_hash).sample,
            bot: Telegram.bots[:admin_bot],
            chat_id: ENV['TELEGRAM_APP_OWNER_ID']
          ).send
        end
      end
    end
  end
end
