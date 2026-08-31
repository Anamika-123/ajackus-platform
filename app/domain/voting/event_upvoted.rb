module Voting
  class EventUpvoted < RubyEventStore::Event
    VOTE_TYPE = :up
  end
end
