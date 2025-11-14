class Participant < ApplicationRecord
  belongs_to :competition
  belongs_to :user, optional: true

  has_many :notes, dependent: :destroy
  has_one :ranking, dependent: :destroy

  validates :name, presence: true
  validates :competition_id, uniqueness: { scope: :name }

  after_commit :refresh_competition_rankings

  def display_name
    user&.name.presence || name
  end

  private

  def refresh_competition_rankings
    return unless competition.rankings.exists?

    Ranking.refresh_for_competition!(competition)
  end
end
