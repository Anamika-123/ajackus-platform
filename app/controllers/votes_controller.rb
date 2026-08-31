class VotesController < ApplicationController
  before_action :require_clerk_session!

  rescue_from Voting::AlreadyVoted, with: :handle_already_voted

  def upvote
    command = Voting::Upvote.new(
      event_id: params[:event_id],
      user_id: clerk.user_id
    )
    Rails.configuration.command_bus.call(command)

    redirect_to events_path, notice: "Event upvoted"
  end

  def downvote
     command = Voting::Downvote.new(
      event_id: params[:event_id],
      user_id: clerk.user_id
    )
    Rails.configuration.command_bus.call(command)

    redirect_to events_path, notice: "Event downvoted"
  end

  private

  def handle_already_voted
    redirect_to events_path,
                alert: "You have already voted for this event"
  end
end
