module Admin
  class PresentationsController < BaseController
    before_action :fetch_presentation, only: [:edit, :update, :destroy]

    def index
      @current_page = (params[:page] || 1).to_i
      @presentations = Presentation.order('created_at DESC').page(@current_page)
      @total_records = @presentations.total_count
    end

    def edit; end

    def update
      if @presentation.update(presentation_params)
        if @presentation.video_source == 'youtube' && ENV['ALLOW_UPDATE_VIDEO_SITE'] == 'true'
          update_youtube_details_for(@presentation)
        end

        redirect_to admin_presentations_path, notice: 'Successfully updated presentation'
      else
        flash.now[:alert] = 'Unable to create new token: ' + @presentation.errors.full_messages.join(". ")
        render :edit
      end
    end

    def destroy
      if @presentation.present? && @presentation.destroy
        redirect_to admin_presentations_path, notice: 'Deleted presentation.'
      else
        redirect_to(admin_presentations_path, flash: {error: 'Unable to delete presentation.'})
      end
    end

    private

    def fetch_presentation
      @presentation = Presentation.find(params[:id])
    end

    def presentation_params
      params.require(:presentation).permit(:title, :description)
    end

    def update_youtube_details_for(presentation)
      begin
        youtube_channel = Identity.order('created_at').find_by(provider: 'google_plus')
        youtube_service = YoutubeService.new(access_token: youtube_channel.access_token, refresh_token: youtube_channel.refresh_token)

        options = {
            id: presentation.video_id,
            title: presentation.title,
            description: presentation.description,
        }
        api_response = youtube_service.update_video(options)

        Rails.logger.info("Video id '#{api_response.try(:id)}' was successfully updated.")
      rescue => e
        Rails.logger.error("Failed to update YouTube (#{presentation.video_id}): #{e.message}")
      end
    end
  end
end
