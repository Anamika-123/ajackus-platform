require "rails_helper"

RSpec.describe "Voting", type: :system do
  let(:event) { create(:event, title: "Ruby on Rails meetup") }

  context "when user is signed in" do
    let(:user_id) { "user-system-test" }
    let(:signed_in_user) do
      Clerk::Proxy.new(
        session_claims: { "sub" => "user-system-test" }
      )
    end

    before do
      allow(Clerk::Proxy)
        .to receive(:new)
        .and_return(signed_in_user)
    end

    it "lets a signed-in user cast an up vote through the browser" do
      event
      visit root_path

      expect(page).to have_text("Signed in")
      expect(page).to have_button("Like")

      click_button "Like"

      expect(page).to have_text("Event upvoted")

      expect(
        EventVote.find_by(
          event: event,
          user_id: user_id
        )
      ).to have_attributes(vote_type: "up")
    end

    it "lets a signed-in user cast down vote through the browser" do
      event
      visit root_path

      expect(page).to have_text("Signed in")
      expect(page).to have_button("Dislike")

      click_button "Dislike"

      expect(page).to have_text("Event downvoted")

      expect(
        EventVote.find_by(
          event: event,
          user_id: user_id
        )
      ).to have_attributes(vote_type: "down")
    end

    it "lets a user switch an upvote to a downvote through the browser" do
      event

      visit root_path
      click_button "Like"

      expect(page).to have_text("Event upvoted")
      expect(page).to have_button("Dislike")

      click_button "Dislike"

      expect(page).to have_text("Event downvoted")
      expect(page).to have_text("👍 0")
      expect(page).to have_text("👎 1")
      expect(
        EventVote.find_by(
          event: event,
          user_id: user_id
        )
      ).to have_attributes(vote_type: "down")
    end
  end

  context "when user is not signed in" do
    it "lets the guest see events but not vote" do
      event
      visit root_path

      expect(page).to have_text("Ruby on Rails meetup")

      expect(page).not_to have_button("Like")
      expect(page).not_to have_button("Dislike")

      expect(EventVote.count).to eq(0)
    end
  end
end
