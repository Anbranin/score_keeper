class AddFieldsToSpiritScoreSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :spirit_score_sheets, :opponent_id, :integer
  end
end
