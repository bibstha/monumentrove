require_relative "../test_helper"

describe Picture do
  let(:picture) { build(:picture) }

  it "must be valid" do
    picture.must_be :valid?
  end

  it "make sure image field is required" do
    params = { name: "Test Picture Label" }
    obj = Picture.new params
    obj.wont_be :valid?
  end
end
