class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]
  before_action :redirect_signed_in_user, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to after_sign_in_path, notice: "Conta criada! Bem-vindo ao Competition App."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def redirect_signed_in_user
    return unless user_signed_in?

    redirect_to profile_path, alert: "Você já possui acesso. Gerencie sua conta no perfil."
  end

  def user_params
    params.expect(user: %i[name email password password_confirmation])
  end
end
