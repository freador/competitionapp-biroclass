class CreateCompetitionJudges < ActiveRecord::Migration[8.0]
  def change
    create_table :competition_judges do |t|
      t.references :competition, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.string :invitation_token, null: false
      t.bigint :invited_by_id, null: true

      t.timestamps
    end
    add_index :competition_judges, [:competition_id, :user_id], unique: true
    add_index :competition_judges, :invitation_token, unique: true
    add_foreign_key :competition_judges, :users, column: :invited_by_id
  end
end
