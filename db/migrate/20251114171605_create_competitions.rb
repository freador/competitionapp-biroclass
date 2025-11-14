class CreateCompetitions < ActiveRecord::Migration[8.0]
  def change
    create_table :competitions do |t|
      t.string :title, null: false
      t.text :description
      t.text :rules
      t.integer :status, null: false, default: 0
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :competitions, :status
  end
end
