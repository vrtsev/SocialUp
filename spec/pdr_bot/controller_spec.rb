RSpec.describe PdrBot::Controller, telegram_bot: :poller do

  let(:bot) { Telegram.bots[:pdr_bot] }
  let(:current_chat) { Fabricate(:pdr_bot_chat) }

  let(:default_message_options) do
    {
      message_id: Faker::Number.number(digits: 4),
      text: text,
      from: from,
      chat: chat,
      date: Time.now.to_i
    }
  end

  let(:from) { { id: 123 } }
  let(:chat) { { id: current_chat.id, type: 'private', title: 'Some chat' } }
  let(:text) { 'allala' }

  describe '#message' do
    describe 'operation' do
      context 'when is successful' do
        describe 'auto answer by received' do
          let!(:auto_answer) { Fabricate(:pdr_bot_auto_answer, chat_id: current_chat.id) }
          subject { -> { dispatch_message(text) } }

          context 'when not found' do
            let(:text) { 'Some random text' }

            it { expect(auto_answer.answer).not_to eq(text) }
            it { expect(subject).not_to send_telegram_message(bot, auto_answer.answer) }
          end

          context 'when exists and found' do
            let(:text) { auto_answer.trigger }

            it { expect(auto_answer.trigger).to eq(text) }
            it { expect(subject).to send_telegram_message(bot, auto_answer.answer) }
          end
        end
      end
    end
  end

  subject { -> { dispatch_command command } }

  describe '#start!' do
    let(:command) { :start }

    it { expect(subject).to send_telegram_message(bot) }
  end

  describe '#pdr!' do
    let(:command) { :pdr }

    it { expect(subject).to send_telegram_message(bot) }
  end

  describe '#results!' do
    let(:command) { :results }

    it { expect(subject).to send_telegram_message(bot) }
  end

  describe '#stats!' do
    let(:command) { :stats }

    it { expect(subject).to send_telegram_message(bot) }
  end

end
