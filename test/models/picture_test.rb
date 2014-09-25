require "test_helper"

describe Picture do
  let(:picture) { build(:picture) }

  it "must be valid" do
    picture.must_be :valid?
  end

  it "can create with requried attributes" do
    params = { name: "Test Picture" }
    obj = Picture.create params
    obj.wont_be :new_record?
    obj.name.must_equal "Test Picture"
  end
end
