class TeamsController < ApplicationController
  before_action :authenticate_user!

  def show
    @team = Team.find(params[:id])
    @spirit_scores = @team.spirit_scores
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update team_params
      redirect_to action: :index, notice: 'great success!'
    else
      render :edit
    end
  end

  def index
    @teams = Team.all
  end

  private

  def team_params
    params.require(:team).permit(:saturday_completed, :sunday_completed, :competition_finish)
  end
end
