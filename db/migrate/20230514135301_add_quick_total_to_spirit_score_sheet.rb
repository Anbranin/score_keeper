class AddQuickTotalToSpiritScoreSheet < ActiveRecord::Migration[7.0]
  def change
    add_column :spirit_score_sheets, :quick_total, :integer
  end
end
