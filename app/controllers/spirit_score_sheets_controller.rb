class SpiritScoreSheetsController < ApplicationController
  before_action :authenticate_user!, except: :averages
  def new
    today = Date.today.strftime('%A')
    @spirit_score_sheet = SpiritScoreSheet.new(day: today)
    @team = Team.find(params[:team_id])
    @opponents = Team.where(division: @team.division)
  end

  def quick_form
    today = Date.today.strftime('%A')
    @spirit_score_sheet = SpiritScoreSheet.new(day: today)
    @team = Team.find(params[:team_id])
    @opponents = Team.where(division: @team.division)
  end

  def create
    @spirit_score_sheet = SpiritScoreSheet.new spirit_score_sheet_params
    action = if params[:spirit_score_sheet][:quick_total]
               :quick_form
             else
               :new
             end
    @team = @spirit_score_sheet.team
    @team.update(saturday_completed: params[:saturday_completed]) if params[:saturday_completed].present?
    @team.update(sunday_completed: params[:sunday_completed]) if params[:sunday_completed].present?
    @opponents = Team.where(division: @team.division)
    if @spirit_score_sheet.save
      redirect_to action: action, team_id: @team.id and return
    end
    render action
  end

  def index
    @spirit_score_sheets = SpiritScoreSheet.all
  end

  def averages
    @division = Division.find(params[:division_id])
    @teams = @division.teams.joins(:spirit_score_sheets).distinct
  end

  private

  def spirit_score_sheet_params
    params.require(:spirit_score_sheet).permit(:team_id, :day, :quick_total, :rules_knowledge_and_use, :fouls_and_body_contact,
                   :fair_mindedness, :positive_attitude_and_self_control, :communication, :comment, :opponent_id)
  end
end
