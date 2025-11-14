class Competition < ApplicationRecord
  enum :status, { draft: 0, open: 1, closed: 2 }, default: :draft

  belongs_to :owner, class_name: "User", inverse_of: :owned_competitions
  has_many :participants, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :rankings, -> { order(position: :asc) }, dependent: :destroy
  has_many :judge_assignments, class_name: "CompetitionJudge", dependent: :destroy
  has_many :judges, through: :judge_assignments, source: :user

  validates :title, presence: true
  validates :owner, presence: true
  validates :rules, presence: true, if: -> { open? || closed? }

  scope :publicly_visible, -> { where(status: %i[open closed]).order(updated_at: :desc) }

  def ready_to_publish?
    participants.exists? && judge_assignments.exists?
  end

  def leaderboard_rows
    return rankings.includes(:participant) if rankings.exists?

    participants
      .left_outer_joins(:notes)
      .select("participants.*, COALESCE(AVG(notes.score), 0) AS average_score")
      .group("participants.id")
      .order(Arel.sql("average_score DESC"))
  end

  def accepted_judge?(user)
    return false if user.nil?

    judge_assignments.accepted.exists?(user: user)
  end

  def needs_scores_from?(user)
    return false if user.nil?

    participant_total = participants.count
    return false if participant_total.zero?

    user.notes.where(competition: self).count < participant_total
  end

  def broadcast_leaderboard!
    Turbo::StreamsChannel.broadcast_replace_to(
      [ :competition, self, :leaderboard ],
      target: ActionView::RecordIdentifier.dom_id(self, :leaderboard),
      partial: "competitions/leaderboard",
      locals: { competition: self, leaderboard: leaderboard_rows }
    )
  end
end
