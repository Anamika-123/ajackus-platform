require "rails_helper"

RSpec.describe "Votes", type: :request do
  let(:event) { create(:event) }

  shared_examples "an authenticated endpoint" do |path_helper|
    it "redirects a guest to Clerk sign-in without recording a vote" do
      post public_send(path_helper, event)

      expect(response).to redirect_to(ENV.fetch("CLERK_SIGN_IN_URL"))
      expect(EventVote.exists?(event: event)).to be(false)
    end
  end

  include_examples "an authenticated endpoint", :upvote_event_vote_path
  include_examples "an authenticated endpoint", :downvote_event_vote_path

  context "when signed in" do
    let(:user_id) { "user-request-spec" }
    let(:signed_in_user) do
      Clerk::Proxy.new(session_claims: { "sub" => user_id })
    end

    before do
      allow(Clerk::Proxy).to receive(:new).and_return(signed_in_user)
    end

    it "records an upvote" do
      expect {
        post upvote_event_vote_path(event)
      }.to change { EventVote.where(event: event, user_id: user_id).count }.from(0).to(1)

      expect(response).to redirect_to(events_path)
      expect(EventVote.find_by!(event: event, user_id: user_id)).to have_attributes(vote_type: "up")
    end

    it "records a downvote" do
      post downvote_event_vote_path(event)

      expect(response).to redirect_to(events_path)
      expect(EventVote.find_by!(event: event, user_id: user_id)).to have_attributes(vote_type: "down")
    end

    it "allows a user to switch from an upvote to a downvote" do
      create(:event_vote, event: event, user_id: user_id, vote_type: "up")

      expect {
        post downvote_event_vote_path(event)
      }.not_to change(EventVote, :count)

      expect(EventVote.find_by!(event: event, user_id: user_id)).to have_attributes(vote_type: "down")
    end

    it "does not record a repeated vote of the same type" do
      create(:event_vote, event: event, user_id: user_id, vote_type: "up")

      expect {
        post upvote_event_vote_path(event)
      }.not_to change(EventVote, :count)

      expect(response).to redirect_to(events_path)
      expect(flash[:alert]).to eq("You have already voted for this event")
    end
  end
end
