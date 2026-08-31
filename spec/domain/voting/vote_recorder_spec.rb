require "rails_helper"

RSpec.describe Voting::VoteRecorder do
  let(:event) { create(:event) }
  let(:user_id) { "user-1" }

  it "records an upvote" do
    described_class.new.call(Voting::EventUpvoted.new(data: { event_id: event.id, user_id: }))

    expect(EventVote.find_by!(event:, user_id:)).to have_attributes(vote_type: "up")
  end

  it "changes an existing upvote to a downvote" do
    create(:event_vote, event:, user_id:, vote_type: "up")

    described_class.new.call(Voting::EventDownvoted.new(data: { event_id: event.id, user_id: }))

    expect(EventVote.find_by!(event:, user_id:)).to have_attributes(vote_type: "down")
  end
end
