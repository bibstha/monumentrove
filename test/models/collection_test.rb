require "test_helper"

describe Collection do
  let(:collection) { Collection.new }

  it "must be valid" do
    collection.must_be :valid?
  end
end
