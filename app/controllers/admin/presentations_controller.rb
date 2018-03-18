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
        if @presentation.video_source == 'youtube' && ENV['ALLOW_UPDATE_VIDEO_SITE'] == 'true' &&  @presentation.has_video_link?
          update_youtube_details_for(@presentation)
        end

        redirect_to admin_presentations_path, notice: 'Successfully updated presentation'
      else
        flash.now[:alert] = 'Unable to update presentation: ' + @presentation.errors.full_messages.join(". ")
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

    def new
      @recordings = Recording.ready

      @event = params[:event_id] ? Event.find(params[:event_id]) : Event.new
      event_details = Event.details_for_presentation(@event, current_user)

      @presentation = Presentation.new(event_details.merge(published: false, event_id: @event.id))
    end

    def create
      @presentation = Presentation.new(presentation_params)

      if @presentation.save
        if transient_params[:event_id]
          @presentation.event_videos.where(event_id: transient_params[:event_id]).first_or_create
        end

        if transient_params[:recording_id]
          Recording.find(transient_params[:recording_id]).update(status: 'prepare_to_publish')
        end

        redirect_to admin_presentations_path, notice: 'Successfully created presentation'
      else
        @recordings = Recording.ready
        @presentation.recording_id = transient_params[:recording_id]
        @presentation.event_id = transient_params[:event_id]
        flash.now[:alert] = 'Unable to create new presentation: ' + @presentation.errors.full_messages.join(". ")
        render :edit
      end
    end

    def create_from_youtube
      begin
        video_item = youtube_service.get_video(params[:presentation][:video_id])
        @presentation = Presentation.from_youtube(video_item)

        if @presentation.save
          redirect_to admin_presentations_path, notice: 'Successfully created presentation'
        else
          redirect_to admin_presentations_path, alert: 'Unable to create presentation'
        end
      rescue => e
        redirect_to admin_presentations_path, alert: "Unable to create presentation: #{e.message}"
      end
    end

    private

    def fetch_presentation
      @presentation = Presentation.find(params[:id])
    end

    def presentation_params
      params.require(:presentation).permit(:title, :description, :presented_at, :published)
    end

    def transient_params
      params.require(:presentation).permit(:recording_id, :event_id)
    end

    def update_youtube_details_for(presentation)
      begin
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

    def youtube_channel
      @youtube_channel ||= Identity.order('created_at').find_by(provider: 'google_plus')
    end

    def youtube_service
      @youtube_service ||= YoutubeService.new(access_token: youtube_channel.access_token, refresh_token: youtube_channel.refresh_token)
    end
  end
end
