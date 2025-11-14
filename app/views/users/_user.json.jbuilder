json.extract! user, :id, :name, :email, :role, :invitation_token, :password_digest, :created_at, :updated_at
json.url user_url(user, format: :json)
