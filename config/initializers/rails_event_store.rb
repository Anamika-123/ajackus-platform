Rails.configuration.event_store =
RailsEventStore::Client.new

Rails.application.config.to_prepare do
  Rails.configuration.event_store.subscribe(
    Voting::VoteRecorder.new,
    to: [
      Voting::EventUpvoted,
      Voting::EventDownvoted
    ]
  )
end
