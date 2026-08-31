module Voting
  def self.stream_name(event_id)
    "Events#{event_id}"
  end
end
