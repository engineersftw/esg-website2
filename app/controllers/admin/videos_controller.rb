module Admin
  class VideosController < ApplicationController
    before_action :authenticate_user!

    def index
    end
  end
end
