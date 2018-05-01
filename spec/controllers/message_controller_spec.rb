require "rails_helper"

RSpec.describe MessageController, type: :request do

  context "Authorization" do
    it "should authorize" do
      user = create(:user)
      params = { token: user.token }
      post "/registerMessage", params: params
      expect(response.status).not_to eq(401)
    end

    it "shouldn't authorize" do
      user = create :user
      params = { token: "a" }
      post "/registerMessage", params: params
      expect(response.status).to eq(401)
    end
  end

  context "Register messages" do
    before do
      @user = create(:user)
    end

    it "should register one message" do
      params = { token:      @user.token,
                message:    "should register one message",
                telegram:   "@cosmos404" }
      post "/registerMessage", params: params
      result = JSON.parse(response.body)
      expect(result["registered_messages"]).to match_array([1])
    end

    it "should register two messages" do
      params = { token:    @user.token,
                message:  "should register two message",
                telegram: ["@cosmos404", "@user2"] }
      post "/registerMessage", params: params
      result = JSON.parse(response.body)
      expect(result["registered_messages"]).to match_array([2, 3])
    end

    it "should register messages in different messengers" do
      params = { token:    @user.token,
                message:  "should  register messages in different messengers",
                telegram: "@cosmos404",
                viber:    ["@user1", "@user2"],
                whats_up: ["@user1", "@user2"] }
      post "/registerMessage", params: params

      result = JSON.parse(response.body)
      expect(result["registered_messages"]).to match_array([4, 5, 6, 7, 8])
    end

    it "should return error bad request" do
      params = { token: @user.token, telegram: "cosmos404" }
      post "/registerMessage", params: params
      expect(response.status).to eq(400)

      params = { token: @user.token, message: "shouldn't return error bad request" }
      post "/registerMessage", params: params
      expect(response.status).to eq(400)
    end

    it "should triggers on message duplicate lock" do
      params = { token:   @user.token,
                message: "should triggers on message duplicate lock",
                telegram:   ["@cosmos404", "@user2"] }
      post "/registerMessage", params: params
      post "/registerMessage", params: params

      result = JSON.parse(response.body)
      expect(result).to have_key "duplicate_messages"
    end

  end
end
