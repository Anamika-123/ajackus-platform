FactoryBot.define do
  factory :event do
    sequence(:billetto_id) { |number| "billetto-#{number}" }
    sequence(:title) { |number| "Event #{number}" }
    start_date { 1.day.from_now }
  end
end
