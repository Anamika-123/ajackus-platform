module Voting
  class VoteRecorder
    def call(event)
      case event
      when ::Voting::EventUpvoted
        record_vote(event, "up")
      when ::Voting::EventDownvoted
        record_vote(event, "down")
      end
    end

    private

    def record_vote(event, vote_type)
      vote = EventVote.find_or_initialize_by(
        event_id: event.data.fetch(:event_id),
        user_id: event.data.fetch(:user_id)
      )

      vote.update!(vote_type: vote_type)
    end
  end
end
