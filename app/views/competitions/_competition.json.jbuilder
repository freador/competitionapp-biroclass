json.extract! competition, :id, :title, :description, :rules, :status, :owner_id, :created_at, :updated_at
json.url competition_url(competition, format: :json)
