class User < ApplicationRecord
  has_secure_password

  enum :role, { user: 0, admin: 1, judge: 2 }, default: :user

  has_many :owned_competitions, class_name: "Competition", foreign_key: "owner_id", inverse_of: :owner, dependent: :nullify
  has_many :notes, foreign_key: "judge_id", inverse_of: :judge, dependent: :destroy

  validates :name, :email, presence: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation :normalize_email

  private

  def normalize_email
    self.email = email.to_s.downcase
  end
end
