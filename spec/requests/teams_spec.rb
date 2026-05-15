require "rails_helper"

RSpec.describe "Teams", type: :request do
  let(:user) { User.create!(email: "teams-spec@example.com", password: "password123") }

  before do
    sign_in user
  end

  describe "GET /teams" do
    it "shows teams with score entry links and completion status" do
      division = Division.create!(name: "Mixed")
      team = Team.create!(name: "PVI", division: division)

      get teams_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Mixed")
      expect(response.body).to include("PVI")
      expect(response.body).to include(new_spirit_score_sheet_path(team_id: team.id))
      expect(response.body).to include("incomplete")
    end
  end

  describe "GET /teams/:id" do
    it "shows spirit score totals and entered spirit scores" do
      division = Division.create!(name: "Open")
      team = Team.create!(name: "PVI", division: division)
      opponent = Team.create!(name: "Rivals", division: division)

      SpiritScoreSheet.create!(
        team: opponent,
        opponent: team,
        day: "Saturday",
        rules_knowledge_and_use: 3,
        fouls_and_body_contact: 3,
        fair_mindedness: 3,
        positive_attitude_and_self_control: 3,
        communication: 3,
        comment: "Great game"
      )

      get team_path(team)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Total Spirit Score")
      expect(response.body).to include("15")
      expect(response.body).to include("Average Spirit Score")
      expect(response.body).to include("15.0")
      expect(response.body).to include("Great game")
    end
  end
end
