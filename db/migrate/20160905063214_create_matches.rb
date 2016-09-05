class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.string :team1
      t.string :team2
      t.integer :total_run_for_team1, default: 0
      t.integer :out_count_for_team1, default: 0
      t.integer :total_run_for_team2, default: 0
      t.integer :out_count_for_team2, default: 0
      t.string :first_batting_team

      t.timestamps
    end
  end
end
