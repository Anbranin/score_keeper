class AddCompetitionFinishToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :competition_finish, :integer
  end
end
