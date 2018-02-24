class ProfileController < ApplicationController
  before_action :authenticate_user!

  def finish_setup
    if request.patch? && params[:user]
      if current_user.update(user_params)
        current_user.skip_reconfirmation!
        bypass_sign_in(current_user)
        redirect_to root_path
      else
        @show_errors = true
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
