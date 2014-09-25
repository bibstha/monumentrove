require "test_helper"

describe Monument do
  let(:monument) { build(:monument) }

  it "must be valid" do
    monument.must_be :valid?
  end

  it "can create with requried attributes" do
    params = { name: "Test Monument" }
    obj = Monument.create params
    obj.wont_be :new_record?
    obj.name.must_equal "Test Monument"
  end
end
