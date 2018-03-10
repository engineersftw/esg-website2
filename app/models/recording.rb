class Recording < ApplicationRecord
  belongs_to :user

  def screenshots
    @screenshots ||= StreamerService.new.screenshots(self.name, self.start_time, self.end_time)
  end
end