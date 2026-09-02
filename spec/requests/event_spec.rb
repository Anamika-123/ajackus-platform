require "rails_helper"

RSpec.describe "Events", type: :request do
  describe "GET /" do
    it "is publicly accessible" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Events")
      expect(response.body).to include("Sign In")
      expect(response.body).to include("Sign Up")
    end

    it "lists events by start date and displays their vote counts" do
      later_event = create(
        :event,
        title: "Later event",
        start_at: 2.days.from_now
      )

      earlier_event = create(
        :event,
        title: "Earlier event",
        start_at: 1.day.from_now
      )

      create_list(
        :event_vote,
        2,
        event: earlier_event,
        vote_type: "up"
      )

      create(
        :event_vote,
        event: earlier_event,
        vote_type: "down"
      )

      create(
        :event_vote,
        event: later_event,
        vote_type: "down"
      )

      get events_path

      expect(response).to have_http_status(:ok)

      expect(response.body.index("Earlier event"))
        .to be < response.body.index("Later event")

      expect(response.body).to include("👍 2")
      expect(response.body).to include("👎 1")
    end
  end
end
