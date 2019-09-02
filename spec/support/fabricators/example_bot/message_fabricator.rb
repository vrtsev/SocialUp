Fabricator(:example_bot_message, from: 'ExampleBot::Message') do
  id                  { Fabricate.sequence(:example_bot_message, 1) }
  chat_id             { |attrs| Fabricate(:example_bot_chat).id }
  text                { Faker::Lorem.sentence }

  created_at          { Time.now }
  updated_at          { Time.now }
end