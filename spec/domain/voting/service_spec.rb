require "rails_helper"

RSpec.describe Voting::Service do
  let(:event_store) { instance_double(RailsEventStore::Client, publish: nil) }
  let(:event) { create(:event) }
  let(:service) { described_class.new(event_store:) }

  it "publishes an upvote" do
    command = Voting::Upvote.new(event_id: event.id, user_id: "user-1")

    expect(event_store).to receive(:publish) do |domain_event, stream_name:|
      expect(domain_event).to be_a(Voting::EventUpvoted)
      expect(domain_event.data).to eq(event_id: event.id, user_id: "user-1")
      expect(stream_name).to eq(Voting.stream_name(event.id))
    end

    service.upvote(command)
  end

  it "rejects a repeated vote of the same type" do
    create(:event_vote, event:, user_id: "user-1", vote_type: "up")

    expect {
      service.upvote(Voting::Upvote.new(event_id: event.id, user_id: "user-1"))
    }.to raise_error(Voting::AlreadyVoted)
  end

  it "allows a user to change an upvote to a downvote" do
    create(:event_vote, event:, user_id: "user-1", vote_type: "up")

    expect(event_store).to receive(:publish).with(
      be_a(Voting::EventDownvoted),
      stream_name: Voting.stream_name(event.id)
    )

    service.downvote(Voting::Downvote.new(event_id: event.id, user_id: "user-1"))
  end
end
