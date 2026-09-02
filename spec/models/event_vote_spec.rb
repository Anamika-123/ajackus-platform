require "rails_helper"

RSpec.describe EventVote, type: :model do
  subject(:event_vote) { build(:event_vote) }

  it { is_expected.to belong_to(:event) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_inclusion_of(:vote_type).in_array(%w[up down]) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:event_id) }
end
