require "test_helper"

describe Monument do
  let(:monument) { Monument.new }

  it "must be valid" do
    monument.must_be :valid?
  end
end
