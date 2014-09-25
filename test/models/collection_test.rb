require "test_helper"

describe Collection do
  let(:collection) { build(:collection) }

  it "must be valid" do
    collection.must_be :valid?
  end

  it "name cannot be empty" do
    collection = build(:collection, name: '')
    collection.wont_be :valid?
  end

  it "can create with requried attributes" do
    params = { name: "Test Collection" }
    obj = Collection.create params
    obj.wont_be :new_record?
    obj.name.must_equal "Test Collection"
  end
end
