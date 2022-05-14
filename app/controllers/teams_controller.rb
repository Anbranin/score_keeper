class TeamsController < ApplicationController

  def index
    @teams = Team.all
  end

  def spirit_intake_form
    return if request.get?

    @teams = Team.where(division: Division.find_by(name: params[:division_name]))
  end

  private

  def spirit_score_sheet_params
    params.require(:spirit_score_sheet).permit(:team)
  end
end
