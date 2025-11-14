class CreateRankings < ActiveRecord::Migration[8.0]
  def change
    create_table :rankings do |t|
      t.references :participant, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true
      t.decimal :total_score, precision: 5, scale: 2, null: false, default: 0
      t.integer :position, null: false

      t.timestamps
    end
    add_index :rankings, [:competition_id, :participant_id], unique: true
    add_index :rankings, [:competition_id, :position], unique: true
  end
end
