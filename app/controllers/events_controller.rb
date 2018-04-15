class EventsController < ApplicationController
  def index
    @current_page = (params[:page] || 1).to_i
    @events = Event.active.upcoming.order('start_datetime ASC, title ASC').page(@current_page).per(15)
    @total_records = @events.total_count
  end

  def history
    @current_page = (params[:page] || 1).to_i
    @events = Event.active.past.order('start_datetime DESC, title ASC').page(@current_page).per(15)
    @total_records = @events.total_count
  end

  def search
    @search = search_param[:search]
    @event_date = search_param[:event_date]
    @events = []

    if @search.present? || @event_date.present?
      @events = Event.active.order('start_datetime DESC')
      if @search.present?
        @events = @events.where('lower(title) like :term or lower(description) like :term', {term: "%#{@search.downcase}%"})
      end
      @events = @events.where(event_date: @event_date) if @event_date.present?
    end
  end

  private

  def search_param
    params.permit(:search, :event_date)
  end
end