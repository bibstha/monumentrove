require_relative "../test_helper"

describe Search do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  before do
    category1 = create(:category, name: "Asian", user: user1)
    category2 = create(:category, name: "African", user: user1)

    monument1 = create(:monument, user: user1, name: "Silver Pagoda", category: category1)
    monument2 = create(:monument, user: user1, name: "Great Wall of China", category: category1)
    monument3 = create(:monument, user: user1, name: "African Abu Mena", category: category2)
    monument4 = create(:monument, user: user1, name: "Victoria Falls", category: category2)

    category3 = create(:category, name: "African", user: user2)
    monument5 = create(:monument, user: user2, name: "Agave", category: category3)
  end

  it "contains 5 results by default" do
    Search.all.count.must_equal 5
  end

  it "searchs in category field" do
    query = "Asian"
    results = Search.new(query, user1.id).results
    results.length.must_equal 2
    results.map(&:monument_name).each do |monument_name|
      ["Silver Pagoda", "Great Wall of China"].must_include monument_name
    end
  end

  it "searches in name field" do
    query = "Wall"
    results = Search.new(query, user1.id).results
    results.length.must_equal 1
    results.map(&:monument_name).must_equal ["Great Wall of China"]
  end

  it "searches in both field together" do
    query = "African"
    results = Search.new(query, user1.id).results
    results.length.must_equal 2
    results.map(&:monument_name).must_equal ["African Abu Mena", "Victoria Falls"]
  end
end
