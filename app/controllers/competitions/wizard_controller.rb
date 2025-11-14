module Competitions
  class WizardController < ApplicationController
    STEPS = %w[details judges participants].freeze

    def show
      @step = step_param
      @wizard = load_wizard
      @competition = current_user.owned_competitions.new(@wizard["competition"] || {})
      @judge_emails = (@wizard["judges"] || []).join("\n")
      @participant_names = participant_lines(@wizard["participants"])
    end

    def update
      @step = step_param
      wizard = load_wizard
      @wizard = wizard

      case @step
      when "details"
        attrs = competition_details_params
        if attrs[:title].blank?
          return render_error_step("details", wizard, "Informe um título para a competição.")
        end

        wizard["competition"] = attrs
        save_wizard(wizard)
        redirect_to competition_builder_path(step: next_step(@step)), notice: "Detalhes salvos!" and return
      when "judges"
        emails = normalized_emails
        if emails.blank?
          return render_error_step("judges", wizard, "Adicione pelo menos um email de jurado.")
        end

        wizard["judges"] = emails
        save_wizard(wizard)
        redirect_to competition_builder_path(step: next_step(@step)), notice: "Jurados adicionados!" and return
      when "participants"
        participants = normalized_participants
        if participants.blank?
          return render_error_step("participants", wizard, "Cadastre pelo menos um participante.")
        end
        if (wizard["judges"] || []).blank?
          return render_error_step("judges", wizard, "Adicione ao menos um jurado antes de finalizar.")
        end
        if (wizard["competition"] || {})["title"].blank?
          return render_error_step("details", wizard, "Informe um título válido antes de concluir.")
        end

        wizard["participants"] = participants
        save_wizard(wizard)
        begin
          competition = persist_wizard!(wizard)
          reset_wizard!
          redirect_to competition_path(competition), notice: "Competição criada com sucesso!"
        rescue ActiveRecord::RecordInvalid => e
          render_error_step("details", wizard, e.record.errors.full_messages.to_sentence)
        end
      else
        redirect_to competition_builder_path(step: STEPS.first), alert: "Etapa inválida."
      end
    end

    private

    def load_wizard
      session[:competition_wizard] ||= { "competition" => {}, "judges" => [], "participants" => [] }
    end

    def save_wizard(data)
      session[:competition_wizard] = data
    end

    def reset_wizard!
      session.delete(:competition_wizard)
    end

    def step_param
      step = params[:step].presence || STEPS.first
      STEPS.include?(step) ? step : STEPS.first
    end

    def next_step(current_step)
      index = STEPS.index(current_step) || 0
      STEPS[[index + 1, STEPS.length - 1].min]
    end

    def competition_details_params
      attrs = params.expect(competition: [ :title, :description, :rules ])
      attrs[:status] = "draft"
      attrs
    end

    def normalized_emails
      params[:judge_emails].to_s.split(/[,;\n]+/).map { |email| email.strip.downcase }.reject(&:blank?).uniq
    end

    def normalized_participants
      params[:participant_names].to_s.split(/\n/).map do |line|
        text = line.strip
        next if text.blank?

        if text.include?("<") && text.include?(">")
          name = text.split("<").first.strip
          email = text[/<(.*)>/, 1]&.strip&.downcase
        else
          name = text
          email = nil
        end
        next if name.blank?

        { "name" => name, "email" => email }
      end.compact.uniq { |entry| entry["name"].downcase }
    end

    def persist_wizard!(data)
      details = data["competition"] || {}
      judges = data["judges"] || []
      participants = data["participants"] || []

      Competition.transaction do
        competition = current_user.owned_competitions.create!(details)
        participants.each do |participant_data|
          normalized = normalize_participant_hash(participant_data)
          competition.participants.create!(
            name: normalized["name"],
            email: normalized["email"],
            invited_by: current_user
          )
        end
        judges.each do |email|
          assignment = competition.judge_assignments.find_or_initialize_by(email: email)
          assignment.email ||= email
          assignment.invited_by ||= current_user
          assignment.status = :pending
          assignment.user = nil
          assignment.save!
        end
        competition
      end
    end

    def render_error_step(step, wizard, message)
      flash.now[:alert] = message
      @step = step
      @wizard = wizard
      @competition = current_user.owned_competitions.new(wizard["competition"])
      @judge_emails = (@wizard["judges"] || []).join("\n")
      @participant_names = participant_lines(@wizard["participants"])
      render :show, status: :unprocessable_entity
    end

    def participant_lines(list)
      Array(list).map { |participant| format_participant_line(participant) }.join("\n")
    end

    def format_participant_line(participant)
      return "" unless participant

      normalized = normalize_participant_hash(participant)
      email = normalized["email"]
      email.present? ? "#{normalized['name']} <#{email}>" : normalized["name"]
    end

    def normalize_participant_hash(participant)
      if participant.is_a?(String)
        { "name" => participant, "email" => nil }
      else
        {
          "name" => participant["name"] || participant[:name],
          "email" => participant["email"] || participant[:email]
        }
      end
    end
  end
end
