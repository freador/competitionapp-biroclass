require "securerandom"

class AddInvitationFieldsToParticipants < ActiveRecord::Migration[8.0]
  class Participant < ApplicationRecord
    self.table_name = :participants
  end

  def up
    add_column :participants, :invitation_token, :string
    add_column :participants, :invited_by_id, :bigint
    add_column :participants, :email, :string

    Participant.reset_column_information
    Participant.find_each do |participant|
      participant.update_columns(invitation_token: SecureRandom.uuid) if participant.invitation_token.blank?
    end

    change_column_null :participants, :invitation_token, false
    add_index :participants, :invitation_token, unique: true
    add_index :participants, :invited_by_id
    add_foreign_key :participants, :users, column: :invited_by_id
  end

  def down
    remove_foreign_key :participants, column: :invited_by_id
    remove_index :participants, :invitation_token
    remove_index :participants, :invited_by_id
    remove_column :participants, :invitation_token
    remove_column :participants, :invited_by_id
    remove_column :participants, :email
  end
end
