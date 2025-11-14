class CompetitionJudge < ApplicationRecord
  belongs_to :competition
  belongs_to :user, optional: true
  belongs_to :invited_by, class_name: "User", optional: true

  enum :status, { pending: 0, accepted: 1, declined: 2 }, default: :pending

  validates :email, presence: true
  validates :invitation_token, presence: true, uniqueness: true
  validates :user_id, uniqueness: { scope: :competition_id }, allow_nil: true

  before_validation :ensure_invitation_token
  before_validation :ensure_email
  before_validation :downcase_email

  scope :pending, -> { where(status: :pending) }

  def invitation_path
    Rails.application.routes.url_helpers.invite_path(token: invitation_token)
  end

  def accept!(user)
    update!(user: user, status: :accepted, email: user.email)
  end

  private

  def ensure_invitation_token
    self.invitation_token ||= SecureRandom.uuid
  end

  def ensure_email
    self.email ||= user&.email
  end

  def downcase_email
    self.email = email.to_s.downcase.presence
  end
end
