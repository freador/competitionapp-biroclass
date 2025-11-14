json.extract! note, :id, :judge_id, :participant_id, :competition_id, :score, :comment, :created_at, :updated_at
json.url note_url(note, format: :json)
