class Event < ApplicationRecord
  enum schedule_status: { not_recording: 0, needs_permission: 1, needs_volunteer: 2, set_allocated: 3 }

  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where('start_datetime >= ?', Time.now.localtime.beginning_of_day.to_datetime) }
  scope :past, -> { where('start_datetime < ?', Time.now.localtime.beginning_of_day.to_datetime) }
end
