class SpiritScoreSheetController < ApplicationController
  def new
    @team = Team.find(params[:team_id])
  end

  def index
    @teams = Team.all
  end
end
