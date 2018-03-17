class Recording < ApplicationRecord
  belongs_to :user

  scope :ready, -> { where(status: 'recording_done') }

  def title
    "Recorded by #{user.name} on #{start_time.strftime('%e-%b-%Y %I:%M %P')}"
  end

  def cover
    screenshots&.first
  end

  def screenshots
    @screenshots ||= StreamerService.new.screenshots(self.name, self.start_time, self.end_time)
  end
end