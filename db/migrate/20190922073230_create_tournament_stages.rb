class CreateTournamentStages < ActiveRecord::Migration[5.2]
  def change
    create_table :tournament_stages do |t|
      t.string :title
      t.integer :total_points
      t.string :result
      t.references :tournament, foreign_key: true
      t.references :division, foreign_key: true
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
