require "rails_helper"

RSpec.describe EventVote, type: :model do
  it "requires a supported vote type" do
    vote = build(:event_vote, vote_type: "sideways")

    expect(vote).not_to be_valid
    expect(vote.errors[:vote_type]).to include("is not included in the list")
  end

  it "allows one vote per user and event" do
    existing_vote = create(:event_vote)
    duplicate_vote = build(:event_vote, event: existing_vote.event, user_id: existing_vote.user_id)

    expect(duplicate_vote).not_to be_valid
    expect(duplicate_vote.errors[:user_id]).to include("has already been taken")
  end
end
