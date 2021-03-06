module Admin
  class RecordingsController < BaseController
    def index
      @current_page = (params[:page] || 1).to_i
      @recordings = Recording.order('start_time DESC').page(@current_page)
      @total_records = @recordings.total_count
    end
  end
end
