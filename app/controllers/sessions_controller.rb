class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create]

  def new
    return redirect_to(after_sign_in_path) if user_signed_in?

    @user = User.new
  end

  def create
    attrs = session_params
    user = User.find_by(email: attrs[:email].to_s.downcase)

    if user&.authenticate(attrs[:password])
      reset_session
      session[:user_id] = user.id
      redirect_to after_sign_in_path, notice: "Bem-vindo de volta, #{user.name}!"
    else
      @user = User.new(email: attrs[:email])
      flash.now[:alert] = "Email ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, notice: "Você saiu da plataforma."
  end

  private

  def session_params
    params.expect(session: [ :email, :password ])
  end
end
