class CommandBus
  def call(command)
    case command
    when Voting::Upvote
      Voting::Service.new.upvote(command)
    when Voting::Downvote
      Voting::Service.new.downvote(command)
    else
      raise ArgumentError, "No handler registered for #{command.class}"
    end
  end
end
