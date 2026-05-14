require "rails_helper"

RSpec.describe "Root page", type: :request do
  it "loads successfully" do
    get root_path

    expect(response).to have_http_status(:ok)
    expect(Nokogiri::HTML(response.body).at_css("table.table")).not_to be_nil
  end
end
