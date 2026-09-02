require "rails_helper"

RSpec.describe Event, type: :model do
  subject(:event) { build(:event) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:start_at) }
  it { is_expected.to validate_presence_of(:billetto_id) }
  it { is_expected.to validate_uniqueness_of(:billetto_id) }
end
