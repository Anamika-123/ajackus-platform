class SessionsController < ApplicationController
  before_action :require_clerk_session!

  def destroy
    Clerk::SDK.new.sessions.revoke(session_id: clerk.session.fetch("sid"))
    cookies.delete Clerk::SESSION_COOKIE

    redirect_to root_path, notice: "Signed out successfully"
  end
end
