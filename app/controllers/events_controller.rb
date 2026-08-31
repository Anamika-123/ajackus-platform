class EventsController < ApplicationController
  def index
    @events = Event.order(start_date: :asc)
    @vote_counts = EventVote.where(event_id: @events).group(:event_id, :vote_type).count
  end
end
