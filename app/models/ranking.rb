class Ranking < ApplicationRecord
  belongs_to :participant
  belongs_to :competition

  validates :position, presence: true, numericality: { greater_than: 0 }
  validates :total_score, presence: true
  validates :participant_id, uniqueness: { scope: :competition_id }

  scope :ordered, -> { order(position: :asc) }

  def self.refresh_for_competition!(competition)
    rows = competition.participants
                      .left_outer_joins(:notes)
                      .select("participants.id, COALESCE(AVG(notes.score), 0) AS average_score")
                      .group("participants.id")
                      .order(Arel.sql("average_score DESC, participants.created_at ASC"))

    transaction do
      competition.rankings.delete_all

      rows.each.with_index(1) do |row, index|
        competition.rankings.create!(
          participant_id: row.id,
          total_score: row.average_score.to_f.round(2),
          position: index
        )
      end
    end
  end
end
