class InvitesController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_invitable

  def show
    @user = current_user || User.new(email: default_email)
  end

  def update
    if user_signed_in?
      attach_user!(current_user)
      redirect_to competition_path(@competition), notice: success_message and return
    end

    @user = User.new(invite_user_params)
    @user.role = default_role

    if @user.save
      reset_session
      session[:user_id] = @user.id
      attach_user!(@user)
      redirect_to competition_path(@competition), notice: success_message
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def set_invitable
    token = params.expect(:token)
    @invitable = CompetitionJudge.find_by(invitation_token: token) || Participant.find_by(invitation_token: token)
    raise ActiveRecord::RecordNotFound unless @invitable

    @competition = @invitable.competition
  end

  def invite_user_params
    params.expect(user: [ :name, :email, :password, :password_confirmation ])
  end

  def default_role
    @invitable.is_a?(CompetitionJudge) ? :judge : :user
  end

  def default_email
    case @invitable
    when CompetitionJudge then @invitable.email
    when Participant then @invitable.email
    end
  end

  def attach_user!(user)
    case @invitable
    when CompetitionJudge
      user.judge! unless user.judge?
      return if @invitable.user == user && @invitable.accepted?

      @invitable.accept!(user)
    when Participant
      return if @invitable.user == user

      @invitable.update!(user: user, email: user.email.presence || @invitable.email)
    end
  end

  def success_message
    if @invitable.is_a?(CompetitionJudge)
      "Convite de jurado aceito!"
    else
      "Você agora participa desta competição."
    end
  end
end
