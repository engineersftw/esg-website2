class Event < ApplicationRecord
  enum schedule_status: { not_recording: 0, needs_permission: 1, needs_volunteer: 2, set_allocated: 3 }

  has_many :event_videos
  has_many :presentations, through: :event_videos

  scope :active, -> { where(active: true) }
  scope :upcoming, -> { where('start_datetime >= ?', Time.now.localtime.beginning_of_day.to_datetime) }
  scope :past, -> { where('start_datetime < ?', Time.now.localtime.beginning_of_day.to_datetime) }

  def self.details_for_presentation(event, current_user)
    presentation_title = event.title ? event.title : '<Presentation title>'
    presentation_group = event.group_name ? event.group_name : '<Group Name>'
    presentation_description = event.description ? event.description : '<description here>'

    {
        title: "#{presentation_title} - #{presentation_group}",
        description: <<TXT
Speaker: 

#{presentation_description}

Event Page: #{event.event_url}

Produced by Engineers.SG
Recorded by: #{current_user.name}
TXT
    }
  end
end
