class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.references :judge, null: false, foreign_key: { to_table: :users }
      t.references :participant, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true
      t.integer :score, null: false, default: 0
      t.text :comment

      t.timestamps
    end
    add_index :notes, [:judge_id, :participant_id], unique: true
  end
end
