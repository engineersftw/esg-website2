class AccountController < ApplicationController
  before_action :authenticate_user!

  def index; end

  def recordings
    @current_page = (params[:page] || 1).to_i
    @recordings = current_user.recordings.order('start_time DESC').page(@current_page)
    @total_records = @recordings.total_count
  end

  def finish_setup
    @current_email = finish_setup_email

    if request.patch? && params[:user]
      if current_user.update(user_params)
        current_user.skip_reconfirmation!
        bypass_sign_in(current_user)
        redirect_to root_path
      else
        @show_errors = true
        @current_email = user_params[:email]
      end
    end
  end

  private

  def finish_setup_email
    current_user.identities.last&.email
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
