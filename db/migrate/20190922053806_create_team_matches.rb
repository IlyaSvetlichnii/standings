class CreateTeamMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :team_matches do |t|
      t.references :tournament, foreign_key: true
      t.references :team, foreign_key: true
      t.integer :enemy_team_id
      t.integer :points
      t.string :stage

      t.timestamps
    end
  end
end
