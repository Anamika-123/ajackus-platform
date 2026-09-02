class Event < ApplicationRecord
  validates :billetto_id, presence: true, uniqueness: true
  validates :title, presence: true
  validates :start_at, presence: true

  has_many :event_votes, dependent: :delete_all

  def upvotes_count
    event_votes.where(vote_type: "up").count
  end

  def downvotes_count
    event_votes.where(vote_type: "down").count
  end
end
