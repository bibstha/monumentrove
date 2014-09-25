require_relative "../test_helper"

describe User do
  let(:user) { build(:user) }

  it "must be valid" do
    user.must_be :valid?
  end

  it 'should contain encrypt password' do
    user = build(:user, password: 'secret_password')
    user.save
    user.encrypted_password.wont_be :nil?
    user.encrypted_password.wont_equal 'secret_password'
  end
end
