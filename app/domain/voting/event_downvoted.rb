module Voting
  class EventDownvoted < RubyEventStore::Event
    VOTE_TYPE = :down
  end
end
