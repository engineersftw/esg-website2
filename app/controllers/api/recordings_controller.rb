module Api
  class RecordingsController < ApplicationController
    skip_before_action :verify_authenticity_token
    rescue_from TokenNotFoundException, with: :render_error

    before_action :fetch_recording_user

    def create
      recording = ::Recording.new(
          video_path: recording_params[:path],
          ip_addr: recording_params[:addr],
          user: @recording_user,
      )

      unless recording.save
        return render status: :not_acceptable
      end

      render status: :ok
    end

    private

    def render_error(error)
      Rails.logger.error "Error in RecordingsController: #{error.message}"
      render json: {status: "Something went wrong"}, status: :not_acceptable
    end

    def fetch_recording_user
      token = AccessToken.find_by(access_token: recording_params[:name])
      raise ::TokenNotFoundException if token.nil?

      @recording_user = AccessToken.find_by(access_token: recording_params[:name])&.user
    end

    def recording_params
      # [name] => michaelcheng
      # [addr] => 192.168.33.1
      # [path] => /video_recordings/michaelcheng-1519909265_recorded.mp4

      params.permit(:addr, :name, :path)
    end
  end
end
