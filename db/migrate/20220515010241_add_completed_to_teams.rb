class AddCompletedToTeams < ActiveRecord::Migration[7.0]
  def change
    add_column :teams, :saturday_completed, :boolean, default: false
    add_column :teams, :sunday_completed, :boolean, default: false
  end
end
