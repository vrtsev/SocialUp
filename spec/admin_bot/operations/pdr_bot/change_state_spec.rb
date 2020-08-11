RSpec.describe AdminBot::Op::PdrBot::ChangeState do
  let(:result)       { described_class.call } 

  context 'when state not found' do
    it 'returns default bot state' do
      REDIS.del("#{::Telegram.bots[:pdr_bot].username}:state")
      state = REDIS.get("#{::Telegram.bots[:pdr_bot].username}:state")

      expect(state).to be_nil
      expect(result[:current_state]).to eq(described_class::DEFAULT_BOT_STATE)
    end
  end

  context 'when state present' do
    context 'when bot is enabled' do
      it 'returns false state' do
        REDIS.set("#{::Telegram.bots[:pdr_bot].username}:state", true) 
        expect(result[:current_state]).to be_falsey
      end
    end

    context 'when bot is disabled' do
      it 'returns true state' do
        REDIS.set("#{::Telegram.bots[:pdr_bot].username}:state", false) 
        expect(result[:current_state]).to be_truthy
      end
    end
  end
end

