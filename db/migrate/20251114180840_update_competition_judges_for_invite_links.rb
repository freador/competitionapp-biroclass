class UpdateCompetitionJudgesForInviteLinks < ActiveRecord::Migration[8.0]
  class CompetitionJudge < ApplicationRecord
    self.table_name = :competition_judges
  end

  def up
    add_column :competition_judges, :email, :string
    change_column_null :competition_judges, :user_id, true
    add_index :competition_judges, :email

    CompetitionJudge.reset_column_information
    CompetitionJudge.find_each do |judge|
      next if judge.email.present?

      user_email = User.where(id: judge.user_id).pick(:email)
      judge.update_columns(email: user_email)
    end
  end

  def down
    remove_index :competition_judges, :email
    change_column_null :competition_judges, :user_id, false
    remove_column :competition_judges, :email
  end
end
