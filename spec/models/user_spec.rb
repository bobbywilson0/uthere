require 'rails_helper'

describe User do

  describe ".random_user" do
    let!(:sender) { User.create }
    let!(:random_user) { User.create }

    it "finds a random user" do
      expect(User.random_user(sender)).to eq(random_user)
    end
  end
end
