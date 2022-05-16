class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.text :name
      t.integer :division_id

      t.timestamps
    end
  end
end
