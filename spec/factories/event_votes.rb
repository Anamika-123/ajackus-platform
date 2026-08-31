FactoryBot.define do
  factory :event_vote do
    association :event
    sequence(:user_id) { |number| "user-#{number}" }
    vote_type { "up" }
  end
end
