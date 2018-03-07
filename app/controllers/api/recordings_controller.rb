module Api
  class RecordingsController < ApplicationController
    skip_before_action :verify_authenticity_token
    rescue_from TokenNotFoundException, with: :render_error

    before_action :fetch_recording_user
    before_action :fetch_recording

    def create
      if @recording.present?
        if params[:call] == 'publish'
          @recording.start_time = Time.at(recording_params[:start_time].to_i)
        elsif params[:call] == 'record_done'
          @recording.assign_attributes(
            start_time: Time.at(recording_params[:start_time].to_i),
            end_time: Time.at(recording_params[:end_time].to_i),
            path: recording_params[:path],
            status: 'recording_done'
          )
        end
      end

      unless @recording.save
        return render json: {errors: @recording.errors.full_messages.join(". ")}, status: :not_acceptable
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

    def fetch_recording
      @recording = ::Recording.find_or_initialize_by(
          name: recording_params[:name],
          addr: recording_params[:addr],
          clientid: recording_params[:clientid]) do |r|
        r.user = @recording_user
      end
    end

    def recording_params
      # [name] => michaelcheng
      # [addr] => 192.168.33.1
      # [clientid] => 21
      # [path] => 5a9d40d02f1054.88412131.mp4
      # [start_time] => 1520253162
      # [end_time] => 1520255184

      params.permit(:call, :name, :addr, :clientid, :path, :start_time, :end_time, :recorder, :format)
    end
  end
end
