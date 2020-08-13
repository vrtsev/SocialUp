# frozen_string_literal: true

module AdminBot
  module Op
    module PdrBot
      module Message
        class SendFromBot < Telegram::AppManager::BaseOperation
          class Contract < Dry::Validation::Contract
            params do
              required(:chat_id).filled(:integer)
              required(:text).filled(:string)
            end
          end

          step :validate
          step :send

          def validate(ctx, params:, **)
            ctx[:validation_result] = Contract.new.call(params)
            ctx[:params] = ctx[:validation_result].to_h

            handle_validation_errors(ctx)
          end

          def send(ctx, params:, **)
            ::Telegram::AppManager::Message.new(
              params[:text],
              bot: ::Telegram.bots[:pdr_bot],
              chat_id: params[:chat_id]
            ).send
          end
        end
      end
    end
  end
end
