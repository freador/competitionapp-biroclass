class Note < ApplicationRecord
  belongs_to :judge, class_name: "User"
  belongs_to :participant
  belongs_to :competition

  validates :score,
            presence: true,
            numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :judge_id, uniqueness: { scope: :participant_id }
  validate :competition_accepts_scores

  after_commit :refresh_competition_rankings
  after_commit :broadcast_leaderboard

  private

  def competition_accepts_scores
    return if competition&.open?

    errors.add(:base, "A competição precisa estar aberta para receber notas.")
  end

  def refresh_competition_rankings
    Ranking.refresh_for_competition!(competition)
  end

  def broadcast_leaderboard
    competition.broadcast_leaderboard!
  end
end
