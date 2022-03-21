require 'rails_helper'

RSpec.describe "BankAccounts", type: :request do
  describe "GET /bank_accounts" do
    it "returns http success" do
      get "/bank_accounts"
      expect(response).to have_http_status(:success)
    end
  end
end
