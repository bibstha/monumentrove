require "test_helper"

describe Category do
  let(:category) { build(:category) }

  it "must be valid" do
    category.must_be :valid?
  end
end
