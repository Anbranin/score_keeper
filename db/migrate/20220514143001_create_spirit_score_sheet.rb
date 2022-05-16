class CreateSpiritScoreSheet < ActiveRecord::Migration[7.0]
  def change
    create_table :spirit_score_sheets do |t|
      t.integer :team_id
      t.text :day
      t.integer :rules_knowledge_and_use
      t.integer :fouls_and_body_contact
      t.integer :fair_mindedness
      t.integer :positive_attitude_and_self_control
      t.integer :communication
      t.text :comment

      t.timestamps
    end
  end
end
