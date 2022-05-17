class SpiritScoreSheetsController < ApplicationController
  def new
    today = Date.today.strftime('%A')
    @spirit_score_sheet = SpiritScoreSheet.new(day: today)
    @team = Team.find(params[:team_id])
    @opponents = Team.where(division: @team.division)
  end

  def create
    @spirit_score_sheet = SpiritScoreSheet.new spirit_score_sheet_params
    
    @team = @spirit_score_sheet.team
    @team.update(saturday_completed: params[:saturday_completed]) if params[:saturday_completed].present?
    @team.update(sunday_completed: params[:sunday_completed]) if params[:sunday_completed].present?
    @opponents = Team.where(division: @team.division)
    if @spirit_score_sheet.save
      redirect_to action: :new, team_id: @team.id and return
    end
    render :new
  end

  def index
    @spirit_score_sheets = SpiritScoreSheet.all
  end

  private

  def spirit_score_sheet_params
    params.require(:spirit_score_sheet).permit(:team_id, :day, :rules_knowledge_and_use, :fouls_and_body_contact,
                   :fair_mindedness, :positive_attitude_and_self_control, :communication, :comment, :opponent_id)
  end
end
