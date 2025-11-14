class ProfilesController < ApplicationController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to profile_path, notice: "Perfil atualizado com sucesso.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def profile_params
    permitted = params.expect(user: %i[name email password password_confirmation])
    if permitted[:password].blank?
      permitted.delete(:password)
      permitted.delete(:password_confirmation)
    end
    permitted
  end
end
