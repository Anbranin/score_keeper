require "rails_helper"

RSpec.describe "SpiritScoreSheets", type: :request do
  describe "GET /spirit_score_sheets/new" do
    it "renders a new spirit score form for the team" do
      division = Division.create!(name: "Open")
      team = Team.create!(name: "PVI", division: division)
      Team.create!(name: "Rivals", division: division)

      get new_spirit_score_sheet_path(team_id: team.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New Spirit Score Sheet: #{team.description}")
      expect(response.body).to include("select opponent")
    end
  end

  describe "POST /spirit_score_sheets" do
    it "creates a spirit score sheet and updates completion status" do
      division = Division.create!(name: "Open")
      team = Team.create!(name: "PVI", division: division)
      opponent = Team.create!(name: "Rivals", division: division)

      expect do
        post spirit_score_sheets_path, params: {
          spirit_score_sheet: {
            team_id: team.id,
            opponent_id: opponent.id,
            day: "Saturday",
            rules_knowledge_and_use: 4,
            fouls_and_body_contact: 4,
            fair_mindedness: 4,
            positive_attitude_and_self_control: 4,
            communication: 4,
            comment: "Solid spirit"
          },
          saturday_completed: "true"
        }
      end.to change(SpiritScoreSheet, :count).by(1)

      expect(response).to redirect_to(new_spirit_score_sheet_path(team_id: team.id))
      expect(team.reload.saturday_completed).to be(true)
    end
  end

  describe "GET /spirit_score_sheets" do
    it "lists saved spirit score sheets" do
      division = Division.create!(name: "Open")
      team = Team.create!(name: "PVI", division: division)
      opponent = Team.create!(name: "Rivals", division: division)

      SpiritScoreSheet.create!(
        team: team,
        opponent: opponent,
        day: "Sunday",
        rules_knowledge_and_use: 2,
        fouls_and_body_contact: 2,
        fair_mindedness: 2,
        positive_attitude_and_self_control: 2,
        communication: 2,
        comment: "Good game"
      )

      get spirit_score_sheets_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Spirit Score Sheets")
      expect(response.body).to include("PVI")
      expect(response.body).to include("Rivals")
      expect(response.body).to include("Good game")
    end
  end

  describe "GET /spirit_score_sheets/averages" do
    it "shows averages for teams in the selected division with entered sheets" do
      division = Division.create!(name: "Open")
      other_division = Division.create!(name: "Mixed")
      team = Team.create!(name: "PVI", division: division)
      opponent = Team.create!(name: "Rivals", division: division)
      other_team = Team.create!(name: "Other", division: other_division)

      SpiritScoreSheet.create!(
        team: team,
        opponent: opponent,
        day: "Saturday",
        rules_knowledge_and_use: 3,
        fouls_and_body_contact: 3,
        fair_mindedness: 3,
        positive_attitude_and_self_control: 3,
        communication: 3,
        comment: "Great"
      )
      SpiritScoreSheet.create!(
        team: team,
        opponent: opponent,
        day: "Sunday",
        rules_knowledge_and_use: 4,
        fouls_and_body_contact: 4,
        fair_mindedness: 4,
        positive_attitude_and_self_control: 4,
        communication: 4,
        comment: "Great again"
      )
      SpiritScoreSheet.create!(
        team: other_team,
        opponent: other_team,
        day: "Sunday",
        rules_knowledge_and_use: 2,
        fouls_and_body_contact: 2,
        fair_mindedness: 2,
        positive_attitude_and_self_control: 2,
        communication: 2,
        comment: "Other division"
      )

      get averages_spirit_score_sheets_path(division_id: division.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Spirit Score Sheets for Open")
      expect(response.body).to include("PVI")
      expect(response.body).not_to include("Other")
    end
  end
end
