module Admin
  class EventsController < BaseController
    before_action :fetch_event, only: [:edit, :update]

    def index
      @current_page = (params[:page] || 1).to_i
      @events = Event.active.upcoming.order('start_datetime ASC, title ASC').page(@current_page)
      @total_records = @events.total_count
    end

    def history
      @current_page = (params[:page] || 1).to_i
      @events = Event.active.past.order('start_datetime DESC, title ASC').page(@current_page)
      @total_records = @events.total_count
    end

    def new
      @event = Event.new
    end

    def create
      @event = Event.new(event_params)

      if @event.save
        redirect_to admin_events_path, notice: 'Event created successfully'
      else
        flash.now[:alert] = 'Unable to create event: ' + @event.errors.full_messages.join(". ")
        render :new
      end
    end

    def edit; end

    def update
      @event.scheduled_for_recording = (schedule_params[:schedule_status] != :not_recording)

      if @event.update(schedule_params)
        redirect_to admin_events_path, notice: 'Updated event schedule'
      else
        flash.now[:alert] = 'Unable to update schedule: ' + @event.errors.full_messages.join(". ")
        render :edit
      end
    end

    private

    def fetch_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :description, :location, :event_url, :group_name, :group_url, :start_datetime, :end_datetime, :esg_volunteer1, :esg_volunteer2, :esg_set, :schedule_status)
    end

    def schedule_params
      params.require(:event).permit(:esg_volunteer1, :esg_volunteer2, :esg_set, :schedule_status)
    end
  end
end