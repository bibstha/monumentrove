require "test_helper"

describe Monument do
  let(:monument) { build(:monument) }

  it "must be valid" do
    monument.must_be :valid?
  end
end
