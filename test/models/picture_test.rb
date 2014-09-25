require "test_helper"

describe Picture do
  let(:picture) { build(:picture) }

  it "must be valid" do
    picture.must_be :valid?
  end
end
