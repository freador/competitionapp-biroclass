class Participant < ApplicationRecord
  belongs_to :competition
  belongs_to :user, optional: true
  belongs_to :invited_by, class_name: "User", optional: true

  has_many :notes, dependent: :destroy
  has_one :ranking, dependent: :destroy

  validates :name, presence: true
  validates :competition_id, uniqueness: { scope: :name }
  validates :invitation_token, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  after_commit :refresh_competition_rankings
  before_validation :ensure_invitation_token
  before_validation :downcase_email

  def display_name
    user&.name.presence || name
  end

  private

  def refresh_competition_rankings
    return unless competition.rankings.exists?

    Ranking.refresh_for_competition!(competition)
  end

  def ensure_invitation_token
    self.invitation_token ||= SecureRandom.uuid
  end

  def downcase_email
    self.email = email.to_s.downcase.presence
  end
end
