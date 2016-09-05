class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.string :team1
      t.string :team2
      t.integer :total_run_for_team1
      t.integer :out_count_for_team1
      t.integer :total_run_for_team2
      t.integer :out_count_for_team2

      t.timestamps
    end
  end
end
