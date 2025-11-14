module Competitions
  class NotesController < ApplicationController
    include ActionView::RecordIdentifier

    before_action :set_competition
    before_action :authorize_judge!
    before_action :set_note, only: :update

    def create
      permitted = note_params
      participant = @competition.participants.find(permitted[:participant_id])
      @note = current_user.notes.new(permitted.except(:participant_id))
      @note.participant = participant
      @note.competition = @competition
      @note.judge = current_user

      if @note.save
        render_card(participant:, status: :created)
      else
        render_card(participant:, status: :unprocessable_entity)
      end
    end

    def update
      permitted = note_params
      participant = @note.participant
      if @note.update(permitted.except(:participant_id))
        render_card(participant:, status: :ok)
      else
        render_card(participant:, status: :unprocessable_entity)
      end
    end

    private

    def set_competition
      @competition = Competition.find(params.expect(:competition_id))
    end

    def authorize_judge!
      return if @competition.open? && @competition.judge_assignments.accepted.find_by(user: current_user)

      redirect_to competitions_path, alert: "Apenas jurados de competições abertas podem enviar notas." and return
    end

    def set_note
      @note = current_user.notes.find_by!(competition: @competition, id: params.expect(:id))
    end

    def note_params
      params.expect(note: %i[participant_id score comment])
    end

    def render_card(participant:, status:)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            dom_id(participant, :judging_card),
            partial: "competitions/judging_card",
            locals: { competition: @competition, participant:, note: @note }
          ), status: status
        end
        format.html do
          if status == :unprocessable_entity
            redirect_to judging_competition_path(@competition), alert: "Não foi possível salvar a nota."
          else
            redirect_to judging_competition_path(@competition), notice: "Nota salva com sucesso."
          end
        end
      end
    end
  end
end
