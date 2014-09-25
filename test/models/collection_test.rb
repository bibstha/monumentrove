require "test_helper"

describe Collection do
  let(:collection) { build(:collection) }

  it "must be valid" do
    collection.must_be :valid?
  end
end
