require "test_helper"

describe Category do
  let(:category) { build(:category) }

  it "must be valid" do
    category.must_be :valid?
  end

  it "can create with requried attributes" do
    params = { name: "Test Category" }
    obj = Category.create params
    obj.wont_be :new_record?
    obj.name.must_equal "Test Category"
  end
end
