class Competition < ApplicationRecord
  enum :status, { draft: 0, open: 1, closed: 2 }, default: :draft

  belongs_to :owner, class_name: "User", inverse_of: :owned_competitions
  has_many :participants, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :rankings, -> { order(position: :asc) }, dependent: :destroy
  has_many :judges, -> { distinct }, through: :notes, source: :judge

  validates :title, presence: true
  validates :owner, presence: true
  validates :rules, presence: true, if: -> { open? || closed? }

  scope :publicly_visible, -> { where(status: %i[open closed]).order(updated_at: :desc) }

  def ready_to_publish?
    participants.exists? && judges.exists?
  end

  def leaderboard_rows
    return rankings.includes(:participant) if rankings.exists?

    participants
      .left_outer_joins(:notes)
      .select("participants.*, COALESCE(AVG(notes.score), 0) AS average_score")
      .group("participants.id")
      .order(Arel.sql("average_score DESC"))
  end
end
