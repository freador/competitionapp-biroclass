class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  helper_method :current_user, :user_signed_in?

  private

  def authenticate_user!
    return if user_signed_in?

    store_location!
    redirect_to new_session_path, alert: "Faça login para acessar essa área."
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def store_location!
    return unless request.get?

    session[:return_to] = request.fullpath
  end

  def after_sign_in_path
    session.delete(:return_to) || competitions_path
  end
end
