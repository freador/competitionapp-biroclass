class Note < ApplicationRecord
  belongs_to :judge, class_name: "User"
  belongs_to :participant
  belongs_to :competition

  validates :score,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :judge_id, uniqueness: { scope: :participant_id }

  after_commit :refresh_competition_rankings

  private

  def refresh_competition_rankings
    Ranking.refresh_for_competition!(competition)
  end
end
