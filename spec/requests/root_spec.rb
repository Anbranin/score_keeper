require "rails_helper"

RSpec.describe "Root page", type: :request do
  let(:user) { User.create!(email: "root-spec@example.com", password: "password123") }

  it "loads successfully" do
    sign_in user

    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Division")
  end
end
