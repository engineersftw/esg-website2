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

    def new_from_youtube
      @presentation = Presentation.new
    end

    def create_from_youtube
      begin
        video_item = youtube_service.get_video(params[:presentation][:video_id])

        @presentation = Presentation.new(
            published: true,
            status: :published,
            video_source: 'youtube',
            video_id: video_item.id,
            title: video_item.snippet.title,
            presented_at: video_item.snippet.published_at,
            description: video_item.snippet.description,
            image1: video_item.snippet.thumbnails.default.url,
            image2: video_item.snippet.thumbnails.medium.url,
            image3: video_item.snippet.thumbnails.high.url
        )

        if @presentation.save
          redirect_to admin_presentations_path, notice: 'Successfully created presentation'
        else
          redirect_to admin_presentations_path, alert: 'Unable to create presentation'
        end
      rescue => e
        redirect_to admin_presentations_path, alert: "Unable to create presentation: #{e.message}"
      end
    end

    def new
      @recordings = Recording.ready

      @event = params[:event_id] ? Event.find(params[:event_id]) : Event.new
      event_title = params[:event_id] ? "#{@event.title} - #{@event.group_name}" : '<Presentation title> - <Group Name>'

      description = <<TXT
Speaker: 

#{@event.description ? @event.description : '<description here>'}

Event Page: #{@event.event_url}

Produced by Engineers.SG
Recorded by: #{current_user.name}
TXT

      @presentation = Presentation.new(published: false, title: event_title, description: description, event_id: @event.id)
    end

    def create
      @presentation = Presentation.new(presentation_params)

      if @presentation.save
        redirect_to admin_presentations_path, notice: 'Successfully created presentation'
      else
        @recordings = Recording.ready
        @presentation.recording_id = params[:recording_id]
        @presentation.event_id = params[:event_id]
        flash.now[:alert] = 'Unable to create new presentation: ' + @presentation.errors.full_messages.join(". ")
        render :edit
      end
    end

    private

    def fetch_presentation
      @presentation = Presentation.find(params[:id])
    end

    def presentation_params
      params.require(:presentation).permit(:title, :description, :presented_at, :published)
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
