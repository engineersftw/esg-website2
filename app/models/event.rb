class Event < ApplicationRecord
  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where('start_datetime >= ?', Time.now.localtime.beginning_of_day.to_datetime) }
  scope :past, -> { where('start_datetime < ?', Time.now.localtime.beginning_of_day.to_datetime) }
end
