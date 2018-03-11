module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin

    def ensure_admin
      redirect_to root_path, alert: 'You do not have access to admin functions.' unless current_user.admin?
    end
  end
end