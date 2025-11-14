class CompetitionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ public_index public_dashboard ]

  before_action :set_competition, only: %i[ show edit update destroy public_dashboard ]
  before_action :authorize_owner!, only: %i[ edit update destroy ]

  # GET /competitions or /competitions.json
  def index
    @owned_competitions = current_user.owned_competitions.includes(:participants).order(updated_at: :desc)
    @judge_competitions = current_user.competitions_as_judge.includes(:owner).order(updated_at: :desc)
  end

  def public_index
    @competitions = Competition.publicly_visible.includes(:owner, :participants)
  end

  def public_dashboard
    unless @competition.open? || @competition.closed?
      redirect_to public_competitions_path, alert: "Competition is not published yet." and return
    end

    @participants = @competition.participants.includes(:ranking, :user).order(:name)
    @leaderboard = @competition.leaderboard_rows
  end

  # GET /competitions/1 or /competitions/1.json
  def show
    if @competition.owner == current_user
      @judge_invites = @competition.judge_assignments.order(created_at: :desc)
      @participant_invites = @competition.participants.order(:name)
    end
  end

  # GET /competitions/new
  def new
    redirect_to competition_builder_path(step: params[:step] || Competitions::WizardController::STEPS.first)
  end

  # GET /competitions/1/edit
  def edit
  end

  # POST /competitions or /competitions.json
  def create
    @competition = current_user.owned_competitions.new(competition_params)

    respond_to do |format|
      if @competition.save
        format.html { redirect_to @competition, notice: "Competition was successfully created." }
        format.json { render :show, status: :created, location: @competition }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /competitions/1 or /competitions/1.json
  def update
    respond_to do |format|
      if @competition.update(competition_params)
        format.html { redirect_to @competition, notice: "Competition was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @competition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /competitions/1 or /competitions/1.json
  def destroy
    @competition.destroy!

    respond_to do |format|
      format.html { redirect_to competitions_path, notice: "Competition was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_competition
      @competition = Competition.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def competition_params
      params.expect(competition: [ :title, :description, :rules, :status ])
    end

    def authorize_owner!
      return if @competition.owner == current_user

      redirect_to competitions_path, alert: "Acesso restrito ao responsável pela competição."
    end
end
