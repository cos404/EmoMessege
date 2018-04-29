require "rails_helper"

RSpec.describe RecipientController, type: :request do

  context "Show recipient data" do
    before do
      @user = create(:user)
      create(:message, user: @user, attempts: 1, recipient: "@cosmos404", service: :telegram)
      create(:message, user: @user, attempts: 2, recipient: "@cosmos404", service: :telegram)
      create(:message, user: @user, attempts: 3, recipient: "@cosmos404", service: :telegram)
      create(:message, user: @user, attempts: 2, recipient: "@cosmos404", service: :telegram)
      create(:message, user: @user, attempts: 1, recipient: "@cosmos404", service: :telegram)
    end

    it "should return user stats" do
      params = {
        token: @user.token,
        telegram: "@cosmos404" }
      get "/recipientStats", params: params
      result = JSON.parse response.body
      expected_result = { "recipient" => "@cosmos404",
                         "attempts_count" => 9,
                         "messages_count" => 5,
                         "failure_rate" => 44.44 }

      expect(result["recipient"]).to eq(expected_result["recipient"])
      expect(result["attempts_count"]).to eq(expected_result["attempts_count"])
      expect(result["messages_count"]).to eq(expected_result["messages_count"])
      expect(result["failure_rate"].to_f).to eq(expected_result["failure_rate"])
    end

    it "should'n found user" do
      params = { token: @user.token, telegram: "@cosmos_not_found" }
      get "/recipientStats", params: params
      expect(response.status).to eq(422)
    end
  end

end
