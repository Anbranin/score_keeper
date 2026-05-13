require "rails_helper"

RSpec.describe "Root page", type: :request do
  it "loads successfully" do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Division")
  end
end
