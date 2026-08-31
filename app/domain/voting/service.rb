module Voting
  class Service
    attr_reader :event_store
    def initialize(event_store: Rails.configuration.event_store)
      @event_store = event_store
    end

    def upvote(command)
      publish_vote_event(command, EventUpvoted)
    end

    def downvote(command)
      publish_vote_event(command, EventDownvoted)
    end

    private
    def publish_vote_event(command, event_class)
      event = Event.find(command.event_id)

      check_if_already_voted!(event, command.user_id, event_class::VOTE_TYPE)

      event_store.publish(
        event_class.new(
          data: {
            event_id: event.id,
            user_id: command.user_id
          }
        ),
        stream_name: Voting.stream_name(event.id)
      )
    end

    def check_if_already_voted!(event, user_id, vote_type)
      if EventVote.exists?(event_id: event.id, user_id: user_id, vote_type: vote_type)
        raise AlreadyVoted, "User has already voted for this event"
      end
    end
  end
end
